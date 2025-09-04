pipeline {
    agent { label 'nixos-agent' }
    stages {
	stage('Pull Nix') {
	    steps {
		git changelog: false, credentialsId: '329fefc4-6b34-4c35-941a-ba5fd1736773', poll: false, url: 'git@github.com:AaronVerDow/nix.git', branch: 'main'
	    }
	}
	stage('Update') {
	    steps {
		sh '''
		    pwd
		    cd pkgs/my_openscad
		    nix-shell -p nix-prefetch-git jq --run './dirty_update.sh $GIT_COMMIT'
		'''
	    }
	}
	stage('Test') {
	    steps {
		sh '''
		    nix build .#nixosConfigurations.games.config.system.build.toplevel
		'''
	    }
	}
	stage('Commit') {
	    steps {
		sh '''
		    cd pkgs/my_openscad
		    git status
		    git config --local user.email "jenkins@verdow.lan"
		    git config --local user.name "Jenkins"
		    git add .
		    git commit -m "auto update openscad"
		    git status
		'''
	    }
	}
	stage('Push') {
	    steps {
		sshagent(['329fefc4-6b34-4c35-941a-ba5fd1736773']) {
		    sh '''
			git status
			git push origin main
		    '''
		}
	    }
	}
    }
}
