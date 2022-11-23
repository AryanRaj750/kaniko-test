def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline { 
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
              sh '/kaniko/executor --dockerfile Dockerfile  --context=`pwd` --no-push --tarPath `pwd`/build/${IMAGE_NAME}-${BUILD_NUMBER}.tar'               
            }              
        }
      }
    }     
  }
}