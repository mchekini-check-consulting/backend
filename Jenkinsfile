node{


	stage("checkout"){
		checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mchekini-check-consulting/backend.git']])
	}

	stage("build docker image"){
		sh "sudo docker build -t mchekini/backend:1.0 ."
	}

	stage("Push Image to DockerHub Registry"){
		withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'password', usernameVariable: 'username')]) {
			sh "sudo docker login -u $username -p $password"
			sh "sudo docker push mchekini/backend:1.0"
			sh "sudo docker rmi mchekini/backend:1.0"
}
	}
}