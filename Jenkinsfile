pipeline {
    agent none
    stages {
        stage('React-Frontend-Build') {
            agent {
                node {
                    label 'slave1'
                }
            }
            options {
                timeout(time: 1, unit: 'HOURS') 
                retry(1) 
            }
            steps {
                echo 'Building Front-End React App'
                sh   'docker build -f ./sa-frontend/Dockerfile -t sa-frontend ./sa-frontend'
                sh   'docker tag sa-frontend:latest 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-frontend:v1'
                sh   'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 166287152401.dkr.ecr.us-west-2.amazonaws.com'
                sh   'docker push 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-frontend:v1'
                echo 'Build Front-End has finished!'
            }
        }
        stage('Java-WebApp-Build') {
            agent {
                node {
                    label 'slave1'
                }
            }
            steps {
                echo 'Building Java-WebApp'
                sh   'sudo docker build -f ./sa-webapp/Dockerfile -t sa-webapp:latest ./sa-webapp'
                sh   'sudo docker tag sa-webapp:latest 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-webapp:v1'
                sh   'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 166287152401.dkr.ecr.us-west-2.amazonaws.com'
                sh   'docker push 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-webapp:v1'
                echo 'Build Java-WebApp has finished!'
            }
        }
        stage('Python-Build') {
            agent {
                node {
                    label 'slave1'
                }
            }
            steps {
                echo 'Building Python-App'
                sh   'docker build -f ./sa-logic/Dockerfile -t sa-logic:latest ./sa-logic'
                sh   'docker tag sa-logic:latest 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-logic:v1'
                sh   'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 166287152401.dkr.ecr.us-west-2.amazonaws.com'
                sh   'docker push 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-logic:v1'
                echo 'Build Python-App has finished!'
            }
        }
        
    }
}
