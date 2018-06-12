provider "kubernetes" {}

resource "kubernetes_replication_controller" "tbl-server" {
  metadata {
    name = "tbl-server"
    labels {
      App = "tbl-server"
    }
  }
  spec {
    replicas = 2
    selector {
      App = "tbl-server"
    }
    template {
      container {
        image = "gcr.io/the-best-letter/the-best-letter:latest"
        name = "tbl-server"
        port {
          container_port = 8080
        }
        resources {
          limits {
            cpu = "0.5"
            memory = "512Mi"
          }
          requests {
            cpu = "250m"
            memory = "50Mi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "tbl-balancer" {
  metadata {
    name = "tbl-balancer"
  }
  spec {
    selector {
      App = "${kubernetes_replication_controller.tbl-server.metadata.0.labels.App}"
    }
    port {
      port = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

output "tbl-balancer-ip" {
  value = "${kubernetes_service.tbl-balancer.load_balancer_ingress.0.ip}"
}
