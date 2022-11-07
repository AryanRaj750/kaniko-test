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
                /kaniko/executor --dockerfile=`pwd`/Dockerfile \
                                 --context=`pwd` \
                                 --destination=aryan750/testkaniko:v1
              '''               
            }
          }
        }
      }
    }
}
