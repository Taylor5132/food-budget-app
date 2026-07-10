# 비-비밀 설정 (커밋 OK). 비밀번호는 여기 넣지 말 것 → credentials.env
proxmox_endpoint = "https://192.168.0.12:8006/"
proxmox_username = "root@pam"
node_name        = "k8s2"
template_vmid    = 9001
datastore        = "local-lvm"
bridge           = "vmbr0"
gateway          = "192.168.0.1"

# ⚠️ 본인 SSH 공개키로 교체:  cat ~/.ssh/id_ed25519.pub
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEVwVV7f3SzeDoNRtpjceWiefP6trEx7BulQ4wsZuqNR team6@DESKTOP-97HF5IH"

# design.md §8.4 (Docker 베이스라인). memory=MB, balloon_floor 0=벌룬off
vms = {
  vm1_data = { vmid = 201, name = "fb-data", cores = 4, memory = 8192, balloon_floor = 0, disk_gb = 100, ip = "192.168.0.8" }
  vm2_app  = { vmid = 202, name = "fb-app-ai", cores = 6, memory = 7168, balloon_floor = 4096, disk_gb = 80, ip = "192.168.0.9" }
  vm3_ci   = { vmid = 203, name = "fb-ci-harbor", cores = 3, memory = 5120, balloon_floor = 3072, disk_gb = 150, ip = "192.168.0.10" }
  vm4_mon  = { vmid = 204, name = "fb-monitoring", cores = 3, memory = 6144, balloon_floor = 4096, disk_gb = 100, ip = "192.168.0.11" }
}
