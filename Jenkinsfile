pipeline {
  agent none
    environment {
        JAVA_WEB_API = 'http://52.41.117.187:31127/sentiment'
        IMAGE_NAME   = '166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-frontend'

    }
    stages {
        stage('React-Frontend-Image-Build') {
            agent {
                node {
                    label 'slave2'
                }
            }
            options {
                timeout(time: 1, unit: 'HOURS') 
                retry(1) 
            }
            steps {
                echo 'Building Front-End React App'
                sh   "sed  -i 's,http://localhost:8080/sentiment,$JAVA_WEB_API,g' sa-frontend/src/App.js"
                sh   'docker build -f ./sa-frontend/Dockerfile -t sa-frontend ./sa-frontend'
                sh   'docker tag sa-frontend:latest ${IMAGE_NAME}:${IMAGE_TAG}'
                
            }
        } 
    }

}
