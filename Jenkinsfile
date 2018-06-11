node {
  agent {
    docker {
      image 'node:8-onbuild'
    }
  }
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
