def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline { 
  environment {
    AWS_ACCOUNT_ID = 152742397097
    AWS_REGION="us-east-2"
    DOCKER_REPO_BASE_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    DOCKER_REPO_NAME="""${sh(
                returnStdout: true,
                script: 'basename=$(basename $GIT_URL) && echo ${basename%.*}'
            ).trim()}"""
    DEPLOYMENT_STAGE="""${sh(
                returnStdout: true,
                script: 'echo ${GIT_BRANCH#origin/}'
            ).trim()}"""
    IMAGE_NAME="${DOCKER_REPO_BASE_URL}/${DOCKER_REPO_NAME}/${DEPLOYMENT_STAGE}"


  }
  agent {
          kubernetes {
            label 'jenkinsrun'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              name: kaniko              
            spec:
              restartPolicy: Never
              containers:
              - name: kaniko
                image: gcr.io/kaniko-project/executor:debug
                command:
                - /busybox/cat
                tty: true 
            """
          }
        }
  stages {    
    stage('Build Docker Image') {
      steps {
       container('kaniko'){
            script {
              last_started = env.STAGE_NAME
              echo 'Build start'              
              sh '/kaniko/executor --dockerfile Dockerfile  --context=`pwd` --destination=${IMAGE_NAME}:${BUILD_NUMBER} --no-push --oci-layout-path `pwd`/build/ --tarPath `pwd`/build/${DOCKER_REPO_NAME}-${BUILD_NUMBER}.tar'               
            }              
        }
      }
    } 

    stage('Push to ECR') {
       agent {
          kubernetes {
            label 'jenkinsrun'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              name: crane
              namespace: kaniko
            spec:
              restartPolicy: Never
              containers:
              - name: crane
                image: aryan750/aws-crane:v1
            """
           }
        }
       steps {        
         container('crane') {
           script {
             echo 'push to ecr step start'              
             withAWS(credentials: 'jenkins-demo-aws') {             
             sh 'crane auth login ${DOCKER_REPO_BASE_URL} -u AWS -p `aws ecr get-login-password --region ${AWS_REGION}` && \
                 crane push `pwd`/build/${DOCKER_REPO_NAME}-${BUILD_NUMBER}.tar ${IMAGE_NAME}:${BUILD_NUMBER}'
                }                
            }
	        }
        }
      }    
  }
}