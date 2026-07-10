output "vm_ips" {
  description = "프로비저닝된 VM → IP"
  value       = { for k, v in var.vms : v.name => v.ip }
}

output "ssh_targets" {
  description = "SSH 접속 타깃"
  value       = { for k, v in var.vms : v.name => "${var.ci_user}@${v.ip}" }
}
