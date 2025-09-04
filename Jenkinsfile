node{


	stage("checkout"){
		checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mchekini-check-consulting/backend.git']])
	}

	stage("build docker image"){
		sh "sudo docker build -t backend ."
	}
}