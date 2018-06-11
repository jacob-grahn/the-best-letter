pipeline {

  agent {
    docker {
      image 'node:8-onbuild'
    }
  }

  node {
    stages {
      stage('Build') {
        steps {
          sh 'npm run build'
        }
      }
      stage('Test') {
        steps {
          sh 'npm run test'
        }
      }
    }
  }
}
