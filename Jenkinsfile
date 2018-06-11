pipeline {

  agent any

  stages {
    stage('Build') {
      steps {
        sh 'npm install'
        sh 'npm run build'
      }
    }
    stage('Test') {
      steps {
        sh 'npm run test'
      }
    }
    stage('Build Image') {
      steps {
        script {
          def app
          app = docker.build('the-best-letter/the-best-letter')
          docker.withRegistry('https://gcr.io', 'gcr:jenkins-gcr') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
          }
        }
      }
    }
  }
}
