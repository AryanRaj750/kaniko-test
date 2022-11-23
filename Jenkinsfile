def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {
  environment {
    doError = '0'
    AWS_ACCOUNT_ID = 152742397097
    AWS_REGION = "us-east-2"
    DOCKER_REPO_BASE_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    DOCKER_REPO_NAME = """${sh(
                returnStdout: true,
                script: 'basename=$(basename $GIT_URL) && echo ${basename%.*}'
            ).trim()}"""
    HELM_CHART_GIT_REPO_URL = "https://gitlab.com/sq-ia/ref/msa-app/helm.git"
    HELM_CHART_GIT_BRANCH = "qa"
    GIT_USER_EMAIL = "pipelines@squareops.com"
    GIT_USER_NAME = "squareops"  
    DEPLOYMENT_STAGE = """${sh(
                returnStdout: true,
                script: 'echo ${GIT_BRANCH#origin/}'
            ).trim()}"""
    last_started_build_stage = ""   
    IMAGE_NAME="${DOCKER_REPO_BASE_URL}/${DOCKER_REPO_NAME}/${DEPLOYMENT_STAGE}"
    // def scannerHome = tool 'SonarqubeScanner';
    PROJECT_NAME="roboshop"    
  }

  options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  agent {
    kubernetes {
        label 'jenkinsrun'
        defaultContainer 'trivy'
        containerTemplate {
          name 'trivy'
          image 'aquasec/trivy:0.21.1'
          command 'sleep'
          args 'infinity'
        }
    }
  }
  
  stages {
    
    stage('Build and Scan Docker Image') {
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

      steps {
       container('kaniko'){
            script {
              last_started = env.STAGE_NAME
              echo 'Build start'              
              sh '''
                cal
                /kaniko/executor --dockerfile Dockerfile  --context=`pwd` --no-push --tarPath `pwd`/build/kaniko-test.tar
              '''               
            }              
        }

       container('trivy') {
           script {
              last_started = env.STAGE_NAME
              echo 'Scan with trivy'
              sh '''
              trivy image --ignore-unfixed -f json -o scan-report.json $(pwd)/build/kaniko-test.tar
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
            label 'jenkinsrun'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              name: crane              
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
             if ( "$high" < 500 && "$critical" < 80 ) {  
              withAWS(credentials: 'jenkins-demo-aws') {             
                sh '''                
                crane auth login ${DOCKER_REPO_BASE_URL} -u AWS -p `aws ecr get-login-password --region ${AWS_REGION}`
                crane push build/kaniko-test.tar ${IMAGE_NAME}:${BUILD_NUMBER}
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
  }
}