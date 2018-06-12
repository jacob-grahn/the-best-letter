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
    stage('Deploy') {
      steps {
        script {
          def project = 'the-best-letter'
          def appName = 'the-best-letter'
          def imageTag = "gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

          withKubeConfig([credentialsId: 'k8s-credentials', serverUrl: 'https://35.199.150.246']) {

            switch (env.BRANCH_NAME) {
              // Roll out to production
              case "master":
              sh("kubectl --namespace=production apply -f k8s/services/")
              sh("kubectl --namespace=production apply -f k8s/production/")
              sh("echo http://`kubectl --namespace=production get service/${appName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip'` > ${appName}")
              break

              // Roll out a dev environment
              default:
              // Create namespace if it doesn't exist
              sh("kubectl get ns ${env.BRANCH_NAME} || kubectl create ns ${env.BRANCH_NAME}")
              // Don't use public load balancing for development branches
              sh("sed -i.bak 's#LoadBalancer#ClusterIP#' ./k8s/services/frontend.yaml")
              sh("sed -i.bak 's#gcr.io/cloud-solutions-images/gceme:1.0.0#${imageTag}#' ./k8s/dev/*.yaml")
              sh("kubectl --namespace=${env.BRANCH_NAME} apply -f k8s/services/")
              sh("kubectl --namespace=${env.BRANCH_NAME} apply -f k8s/dev/")
              echo 'To access your environment run `kubectl proxy`'
              echo "Then access your service via http://localhost:8001/api/v1/proxy/namespaces/${env.BRANCH_NAME}/services/${feSvcName}:80/"
            }
          }
        }
      }
    }
  }
}
