variable "proxmox_endpoint" {
  description = "Proxmox API 엔드포인트"
  type        = string
  default     = "https://192.168.0.12:8006/"
}

variable "proxmox_username" {
  description = "Proxmox API 사용자 (realm 포함)"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox root 비밀번호 — credentials.env(TF_VAR_proxmox_password)로 주입. 절대 커밋 금지."
  type        = string
  sensitive   = true
}

variable "node_name" {
  description = "PVE 노드명 (hostname)"
  type        = string
  default     = "k8s2"
}

variable "template_vmid" {
  description = "클론 원본 cloud-init 템플릿 VMID"
  type        = number
  default     = 9001
}

variable "datastore" {
  description = "VM 디스크 저장소 (thin)"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "네트워크 브리지"
  type        = string
  default     = "vmbr0"
}

variable "gateway" {
  description = "게이트웨이 IP"
  type        = string
  default     = "192.168.0.1"
}

variable "dns_servers" {
  description = "DNS 서버"
  type        = list(string)
  default     = ["192.168.0.1", "1.1.1.1"]
}

variable "ci_user" {
  description = "cloud-init 기본 사용자"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "cloud-init 주입 SSH 공개키 (본인 것으로 교체)"
  type        = string
}

variable "vms" {
  description = "프로비저닝할 VM 스펙 (design.md §8.4 · Docker 베이스라인)"
  type = map(object({
    vmid           = number
    name           = string
    cores          = number
    memory         = number # MB, dedicated(최대)
    balloon_floor  = number # MB, floating(최소). 0 = 벌룬 off(고정)
    disk_gb        = number # OS 디스크(GB)
    docker_disk_gb = number # /var/lib/docker 전용 디스크(GB)
    ip             = string
  }))
}
