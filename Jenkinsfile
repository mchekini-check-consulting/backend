node{

	def COMMIT_HASH = ""
    def COMMIT_MESSAGE = ""

	stage("checkout"){

		def scmVars = checkout(scm)
   		COMMIT_MESSAGE = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
    	COMMIT_HASH = scmVars?.GIT_COMMIT
        echo "Commit SHA: ${COMMIT_HASH}, COMMIT MESSAGE : ${COMMIT_MESSAGE}"

       if (COMMIT_MESSAGE.contains("[No CI]")) {
			echo "Commit message contient [No CI] → on arrête la pipeline."
            currentBuild.result = 'SUCCESS'
            return
        }
}

	stage("unit tests"){
		sh "./mvnw test"
	}

	stage("Quality Analyses"){
		sh "./mvnw clean verify sonar:sonar \
  				-Dsonar.projectKey=backend \
  				-Dsonar.projectName='backend' \
  				-Dsonar.host.url=http://13.37.213.251:9000 \
  				-Dsonar.token=sqp_1a35d6529017cbe33b9b957eddddb5ee42ab8ef5"
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

	node("int"){
		stage("deploy"){
			try {
				sh "docker stop backend"
				sh "docker rm backend"
				sh "docker run --name backend -p 8080:8080 -d mchekini/backend:1.0"
			}
			catch(Exception e){
				sh "docker run --name backend -p 8080:8080 -d mchekini/backend:1.0"
			}
		}
	}

}