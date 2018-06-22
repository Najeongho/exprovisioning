## Softlayer 접속 정보
provider "ibm" {
    softlayer_api_key = "<API Key>"
    softlayer_username = "<계정명>"
}
 
 
## 생성 VM 정보(스펙)
resource "ibm_compute_vm_instance" "vm-provisioning" {
    hostname = "vm-provisioning"
    domain = "sk.com"
    os_reference_code = "WIN_2012-STD-R2_64"
    datacenter = "seo01"
    network_speed = 100
    hourly_billing = true
    local_disk = false
    private_network_only = false
    cores = 2
    memory = 2048
    disks = [100]
    public_vlan_id = 2251207
    private_vlan_id = 2251209
    post_install_script_uri = "https://seo01.objectstorage.softlayer.net/<Object Storage 경로>/win-provisioner.ps1"  ## Softlayer Object Storage에 Provisioning Code를 업로드 - Code 내용은 (2)번 참조
}
