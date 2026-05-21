provider "proxmox" {
  pm_api_url  = var.pm_api_url
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure = true
  pm_parallel = 10
}

resource "proxmox_vm_qemu" "vm" {
#Hardware Setup

  target_node = var.target_node
  vmid    = "20${count.index + 1}"
  count   = var.vm_count
  name    = var.vm_names[count.index]
  cores   = var.cpu_cores
  memory  = var.memory 
  agent   = 1
  clone   = var.template_name
  full_clone  = true 
  onboot = true
  scsihw   = "virtio-scsi-pci"

   network {
    id = 0
    model = "virtio"
    bridge = var.network_bridge
    #tag =        ##Can be added if needed
    }

#Disk setup

disks {
    ide {
      ide3 {
        cloudinit {
        storage = var.storage
      }
    }
 }
        scsi {
            scsi0 {
                disk {
                size    = var.disk_size
                storage = var.storage
          }
        }
      }
    } 

  lifecycle {
    ignore_changes = [
      network,
    ]
  }


# Cloud init configuration

  ciuser = var.ciuser
  ipconfig0 = "ip=${var.vm_ips[count.index]}/${var.network_cidr},gw=${var.gateway}"
  sshkeys = <<EOF
     ${var.ssh_public_key}
  EOF

}

