pipeline {
    agent any

    stages {
        stage('React-Frontend-Build') {
            agent {
                label slave1
            }
            steps {
                echo "Building Front-End React App"
                sh   sudo docker build -f ./sa-frontend/Dockerfile -t sa-frontend-react:v1 ./sa-frontend
                sh   sudo docker tag sa-frontend-react 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-frontend-react:v1
                sh   sudo docker push 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-frontend-react:v1
                echo "Build Front-End has finished!"
            }
        }
        stage('Java-WebApp-Build') {
            agent {
                label slave1
            }
            steps {
                echo "Building Java-WebApp"
                sh   sudo docker build -f ./sa-webapp/Dockerfile -t sa-webapp:v1 ./sa-webapp
                sh   sudo docker tag sa-webapp 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-webapp:v1
                sh   sudo docker push 166287152401.dkr.ecr.us-west-2.amazonaws.com/sa-webapp:v1
                echo "Build Java-WebApp has finished!"
            }
        }
        stage('Python-Build') {
            agent {
                label slave1
            }
            steps {
                echo "Building Python-App"
                sh   sudo docker build -f ./sa-logic/Dockerfile -t Python-App:v1 ./sa-logic
                sh   sudo docker tag Python-App 166287152401.dkr.ecr.us-west-2.amazonaws.com/Python-App:v1
                sh   sudo docker push 166287152401.dkr.ecr.us-west-2.amazonaws.com/Python-App:v1
                echo "Build Python-App has finished!"
            }
        }
        
    }
}
