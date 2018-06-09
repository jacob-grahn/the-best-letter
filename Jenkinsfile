pipeline {
  def app

  agent {
    docker {
      image 'node:8'
    }
  }

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
    stage('Build Image') {
      app = docker.build('the-best-letter/the-best-letter')
    }
    stage('Push Image') {
      docker.withRegistry('https://gcr.io') {
          app.push("${env.BUILD_NUMBER}")
          app.push("latest")
      }
    }
  }
}
