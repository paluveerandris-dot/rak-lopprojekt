
#!/bin/bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
apt update -y && apt install libguestfs-tools dhcpcd-base -y
virt-customize -a noble-server-cloudimg-amd64.img --install qemu-guest-agent
qm create 8000 --name "ubuntu-2404-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 8000 noble-server-cloudimg-amd64.img ssd-data
qm set 8000 --scsihw virtio-scsi-pci --scsi0 ssd-data:vm-8000-disk-0
qm set 8000 --boot c --bootdisk scsi0
qm set 8000 --ide2 ssd-data:cloudinit
qm set 8000 --serial0 socket --vga serial0
qm set 8000 --agent enabled=1
qm template 8000
