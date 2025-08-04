#!/usr/bin/env bash
# Reformat C++ code using uncrustify

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$SCRIPT_DIR/..

FORMAT_CMD_UNCRUSTIFY="uncrustify -c "$ROOT_DIR/.uncrustify.cfg" --no-backup"
#LLVM|GNU|Google|Chromium|Microsoft|Mozilla|WebKit
FORMAT_CMD_CLANG="clang-format -i --style file:$ROOT_DIR/.clang-format"
FORMAT_CMD=$FORMAT_CMD_CLANG

# Filter out any files that shouldn't be auto-formatted.
# note: -v flag inverts selection - this tells grep to *filter out* anything
#       that matches the pattern. For testing, you can remove the -v to see
#       which files would have been excluded.
FILTER_CMD="grep -v -E ext/"

function find_all() {
    find "$ROOT_DIR/src" \( -name "*.h" -o -name "*.hpp" -o -name "*.cc" -o -name "*.cpp" \) -a -not -name findversion.h \
        | $FILTER_CMD
}

function diff_all() {
    errors=false
    while IFS= read -r file; do
        if ! output=$( clang-format --style file:$ROOT_DIR/.clang-format --dry-run --Werror "$file" 2>&1 ); then
            echo "$output"
            # Using clang-format -output-replacements-xml for diffing
            clang-format --style file:$ROOT_DIR/.clang-format -output-replacements-xml "$file" > "${file}.clang"
            grep -q '<replacement ' "${file}.clang" && (
                echo "Formatting differences found in $file"
                diff "$file" <(clang-format --style file:$ROOT_DIR/.clang-format "$file") || true
            )
            rm -f "${file}.clang"
            errors=true
        fi
    done < <( find_all ) 
    if $errors; then
        echo "Formatting errors found. Please fix using ./scripts/beautify.sh"
        return 1
    else
        echo "All files formatted correctly."
    fi
}


function check_all() {
    errors=false
    while IFS= read -r file; do
        if ! output=$( uncrustify -c "$ROOT_DIR/.uncrustify.cfg" --check "$file" ); then
            echo "$output"
            errors=true
        fi
    done < <( find_all ) 
    if $errors; then
        echo "Formatting errors found. Please fix using ./scripts/beautify.sh"
        return 1
    else
        echo "All files formatted correctly."
    fi
}

function reformat_all() {
    find_all | xargs $FORMAT_CMD
}

# reformat files that differ from master.
DIFFBASE="origin/master"
function reformat_changed() {
    ANCESTOR=$(git merge-base HEAD "$DIFFBASE")
    FILES=$(git --no-pager diff --name-only $ANCESTOR | grep -E "\.(h|hpp|cc|cpp)" | $FILTER_CMD)
    if [ $? -ne 0 ]; then
        echo "No files to format, exiting..."
    else
        echo -e "Reformatting files:\n$FILES"
        echo $FILES | xargs $FORMAT_CMD
    fi
}

# parse options
for PARAM in "$@"
do
  KEY="${PARAM%%=*}"
  if [[ "$PARAM" == *"="* ]]; then
    VALUE="${PARAM#*=}"
  else
    VALUE=""
  fi

  if [ "$KEY" == "--diffbase" ]; then
    [ -z "$var" ] && echo "script option --diffbase=BASE requires a non-empty value" && exit 1
    DIFFBASE="${VALUE}"
  elif [ "$PARAM" == "--check" ]; then
    CHECKALL=1
  elif [ "$PARAM" == "--all" ]; then
    DOALL=1
  elif [ "$KEY" == "-h" ]; then
    SCRIPT=$(basename "$0")
    echo "Runs uncrustify on files which differ from diffbase, OR across the entire project (for --all)"
    echo "If no options given, then diffbase defaults to \"origin/master\""
    echo
    echo "Usage:"
    echo "    $SCRIPT [--all|--diffbase=BASE]"
    echo
    exit
  fi
done


if ((DOALL)); then
    echo "Reformatting all files..."
    reformat_all
elif ((CHECKALL)); then
    echo -n "Checking all files using "
    uncrustify -v
    diff_all
else
    echo "Reformatting files that differ from $DIFFBASE..."
    reformat_changed
fi
