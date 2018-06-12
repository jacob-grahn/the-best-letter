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
          def tag = "${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

          app = docker.build('the-best-letter/the-best-letter')
          docker.withRegistry('https://gcr.io', 'gcr:jenkins-gcr') {
            app.push("${tag}")
            app.push("latest")
          }
        }
      }
    }
    stage('Deploy') {
      steps {
        script {
          def project = 'the-best-letter'
          def appName = 'the-best-letter'
          def tag = "${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
          def imageTag = "gcr.io/${project}/${appName}:${tag}"

          withKubeConfig([credentialsId: 'k8s-credentials', serverUrl: 'https://35.199.150.246']) {

            switch (env.BRANCH_NAME) {
              // Roll out to production
              case "master":
              // sh("sed -i.bak 's#PRODUCTION_IMAGE#${imageTag}#' ./k8s/production/*.yaml")
              // sh("kubectl --namespace=production apply -f k8s/services/")
              // sh("kubectl --namespace=production apply -f k8s/production/")
              sh("sed -i.bak 's#PRODUCTION_IMAGE#${imageTag}#' ./setup.tf")
              sh("sed -i.bak 's#BUILD_NUMBER#${env.BUILD_NUMBER}#' ./setup.tf")
              sh('terraform init')
              sh('terraform apply -auto-approve')
              break

              // Roll out a dev environment
              default:
              echo 'TODO'
            }
          }
        }
      }
    }
  }
}
