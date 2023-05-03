terraform {
    required_providers {
        kind = {
            source = "tehcyx/kind"
                version = "0.0.16"
        }
        kubectl = {
            source  = "gavinbunney/kubectl"
                version = "1.14.0"
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

provider "kubectl" {
        host                    = "${kind_cluster.argo_test.endpoint}"
        cluster_ca_certificate  = "${kind_cluster.argo_test.cluster_ca_certificate}"
        client_certificate      = "${kind_cluster.argo_test.client_certificate}"
        client_key              = "${kind_cluster.argo_test.client_key}"
        load_config_file        = false
}

data "kubectl_file_documents" "namespace" {
    content = file("namespace.yml")
}

resource "kubectl_manifest" "namespace" {
    depends_on = [
      kind_cluster.argo_test,
    ]
    count = length(data.kubectl_file_documents.namespace.documents)
    yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
}

data "kubectl_file_documents" "argocd" {
    content = file("../app/argo/argocd/argocd.yml")
}

resource "kubectl_manifest" "argocd" {
    depends_on = [
      kubectl_manifest.namespace,
    ]
    count = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"
}


data "kubectl_file_documents" "application" {
    content = file("../app/application.yml")
}

resource "kubectl_manifest" "application" {
    depends_on = [
      kubectl_manifest.argocd,
    ]
    count = length(data.kubectl_file_documents.application.documents)
    yaml_body = element(data.kubectl_file_documents.application.documents, count.index)
}

# TODO: Setup Argo in the prod cluster.
resource "kind_cluster" "argo_prod" {
    name = "argo-prod"
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

        }
}
