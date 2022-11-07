pipeline {
    agent {
        kubernetes {
            yamlFile 'kaniko-builder.yaml'            
        }
    }
     stages {
       stage('kaniko build image and push to repository'){

        steps {
          container('kaniko'){
            script {
              sh '''
                /kaniko/executor --dockerfile=Dockerfile
                                 --context=""
                                 --destination=aryan750/test-kaniko:v1
              ''''
               
            }
          }
        }
      }
    }
}
