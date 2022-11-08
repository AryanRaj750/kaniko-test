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
                aws help
                /kaniko/executor --dockerfile=Dockerfile \
                                 --context=`pwd` \
                                 --destination=152742397097.dkr.ecr.us-east-2.amazonaws.com/kaniko-test/kaniko:latest                                
              '''               
            }
          }
        }
      }
    }
}
