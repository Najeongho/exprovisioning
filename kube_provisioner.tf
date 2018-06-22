provider "ibm" {
    region = "ap-north"
    softlayer_api_key = "<My softlayer_api_key>"
    softlayer_username = "<My softlayer_username>"
    bluemix_api_key    = "<My bluemix_api_key>"
}


resource "ibm_container_cluster" "kube_provisioner" {
  name            = "kube_provisioner"
  datacenter      = "seo01"
  kube_version    = "1.9.7_1510"
  machine_type    = "u2c.2x4"
  isolation       = "public"
  public_vlan_id  = 2251207
  private_vlan_id = 2251209
  billing         = "hourly"

  workers = [{
    name = "worker1"
    action = "add"
    version = "1.9.7_1513"
  }]

  account_guid = "<My account_guid>"
}

output "id" {
  value = "${ibm_container_cluster.kube_provisioner.id}"
}

output "name" {
  value = "${ibm_container_cluster.kube_provisioner.name}"
}

output "server_url" {
  value = "${ibm_container_cluster.kube_provisioner.server_url}"
}

output "workers_info" {
  value = "${ibm_container_cluster.kube_provisioner.workers_info}"
}

output "workers_id" {
  value = "${ibm_container_cluster.kube_provisioner.workers.id}"
}
