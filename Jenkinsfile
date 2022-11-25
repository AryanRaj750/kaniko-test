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
      label 'kaniko'
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
              sh '''/kaniko/executor --dockerfile Dockerfile  --context=`pwd` --destination=${IMAGE_NAME}:${BUILD_NUMBER} --no-push --oci-layout-path `pwd`/build/ --tarPath `pwd`/build/${DOCKER_REPO_NAME}-${BUILD_NUMBER}.tar
              '''               
            }   
            stash includes: 'build/*.tar', name: 'image'                
        }
      }
    }
    stage('Scan Docker Image') {
      agent {
        kubernetes {           
            containerTemplate {
              name 'trivy'
              image 'aquasec/trivy:0.21.1'
              command 'sleep'
              args 'infinity'
            }
        }
      }
      options { skipDefaultCheckout() }
      steps {
        container('trivy') {
           script {
              last_started = env.STAGE_NAME
              echo 'Scan with trivy'    
              unstash 'image'          
              sh '''
              trivy image --ignore-unfixed -f json -o scan-report.json --input build/${DOCKER_REPO_NAME}-${BUILD_NUMBER}.tar
              '''
              echo 'archive scan report'
              archiveArtifacts artifacts: 'scan-report.json'
              echo 'Docker Image Vulnerability Scanning'
              high = sh (
                   script: 'cat scan-report.json | jq \'.[].Vulnerabilities[].Severity\' | grep HIGH | wc -l',
                   returnStdout: true
              ).trim()
              echo "High: ${high}"
             
             critical = sh (
                  script: 'cat scan-report.json | jq \'.[].Vulnerabilities[].Severity\' | grep CRITICAL | wc -l',
                   returnStdout: true
              ).trim()
              echo "Critical: ${critical}"             
           }
         }
      } 
    }    

    stage('Push to ECR') {
       agent {
          kubernetes { 
            label 'kaniko'
            }
        }
      //  options { skipDefaultCheckout() }
       steps {        
         container('kaniko') {
           script {
              echo 'push to ecr step start'
              if ( "$high" < 500 && "$critical" < 80 ) {
                withAWS(credentials: 'jenkins-demo-aws') {               
                unstash 'image'  
                sh '''                                   
                /kaniko/executor --context=build/${DOCKER_REPO_NAME}-${BUILD_NUMBER}.tar --destination=${IMAGE_NAME}:${BUILD_NUMBER}
                '''               
                }   
              } 
              else {
                echo "The Image can't be pushed due to too many vulnerbilities"
                exit
              }                                    
            }
	        }
        }
      }  
      // new stage start  
   }
}