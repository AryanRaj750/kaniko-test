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
                echo 'wait for completion...' 
              '''               
            }
          }
        }
      }
    }
}
