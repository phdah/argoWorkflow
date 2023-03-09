terraform {
    required_providers {
        kind = {
            source = "tehcyx/kind"
                version = "0.0.16"
        }
        helm = {
            source = "hashicorp/helm"
                version = "2.9.0"
        }
    }
}

provider "kind" {}

resource "kind_cluster" "argo_test" {
    name = "argo-test"
        wait_for_ready = true
        node_image = "kindest/node:v1.26.0"
        kind_config {
            kind = "Cluster"
                api_version = "kind.x-k8s.io/v1alpha4"

            node {
                role = "control-plane"
            }

            node {
                role = "worker"
            }

            node {
                role = "worker"
            }

            node {
                role = "worker"
            }
        }
}

provider "helm" {
    kubernetes {
        host = "${kind_cluster.argo_test.endpoint}"
            cluster_ca_certificate = "${kind_cluster.argo_test.cluster_ca_certificate}"
            client_certificate = "${kind_cluster.argo_test.client_certificate}"
            client_key = "${kind_cluster.argo_test.client_key}"
    }
}

resource "helm_release" "argocd" {
    name  = "argocd"

        repository       = "https://argoproj.github.io/argo-helm"
        chart            = "argo-cd"
        namespace        = "argocd"
        version          = "4.9.7"
        create_namespace = true

        values = [
        file("argocd_init.yml")
        ]
}
