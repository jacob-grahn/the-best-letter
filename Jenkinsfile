pipeline {

  agent {
    label 'any'
  }

  stages {
    stage('Setup') {
      steps {
        sh 'apt install nodejs -y'
        sh 'apt install docker.io -y'
      }
    }
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
    stage('Deploy') {
      steps {
        echo 'Hello World'
        script {
          def app
          app = docker.build('the-best-letter/the-best-letter')
          docker.withRegistry('https://gcr.io') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
          }
        }
      }
    }
  }
}
