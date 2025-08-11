#!/usr/bin/env bash
# Reformat C++ code using clang-format

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$SCRIPT_DIR/..

FORMAT_CMD="clang-format -i --style file:$ROOT_DIR/.clang-format"
CHECK_CMD="$FORMAT_CMD --dry-run --Werror"
VERSION_CMD="clang-format --version"

# Filter out any files that shouldn't be auto-formatted.
# note: -v flag inverts selection - this tells grep to *filter out* anything
#       that matches the pattern. For testing, you can remove the -v to see
#       which files would have been excluded.
FILTER_CMD="grep -v -E ext/"

function find_all() {
    find "$ROOT_DIR/src" \( -name "*.h" -o -name "*.hpp" -o -name "*.cc" -o -name "*.cpp" \) -a -not -name findversion.h \
        | $FILTER_CMD
}

function check_all() {
    find_all | xargs $CHECK_CMD
}

function reformat_all() {
    find_all | xargs $FORMAT_CMD
}

# reformat files that differ from master.
DIFFBASE="origin/master"
function reformat_changed() {
    ANCESTOR=$(git merge-base HEAD "$DIFFBASE")
    if FILES=$(git --no-pager diff --name-only "$ANCESTOR" | grep -E "\.(h|hpp|cc|cpp)" | $FILTER_CMD); then
        echo -e "Reformatting files:\n$FILES"
        echo $FILES | xargs $FORMAT_CMD
    else
        echo "No files to format, exiting..."
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
    echo "Runs clang-format on files which differ from diffbase, OR across the entire project (for --all)"
    echo "If no options given, then diffbase defaults to \"origin/master\""
    echo
    echo "Usage:"
    echo "    $SCRIPT [--all|--diffbase=BASE]"
    echo
    exit
  fi
done

function execute() {
    # Execute function with version, done message, and preserved return value 
    local function message return_value version
    function=$1
    message=$2

    echo "$message"
    
    "$function"
    return_value=$?

    echo -n "Completed with "
    $VERSION_CMD
    return $return_value
}

if ((DOALL)); then
    execute reformat_all "Reformatting all files..."
elif ((CHECKALL)); then
    execute check_all "Checking all files..."
else
    execute reformat_changed "Reformatting files that differ from $DIFFBASE..."
fi
