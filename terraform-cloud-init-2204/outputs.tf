output "vm_names" {
  description = "Deployed VM hostnames"
  value       = [for vm in proxmox_vm_qemu.vm : vm.name]
}

output "vm_ids" {
  description = "Proxmox VM IDs"
  value       = [for vm in proxmox_vm_qemu.vm : vm.vmid]
}

output "vm_ips" {
  description = "Configured static IPs (from terraform variables)"
  value       = var.vm_ips
}
