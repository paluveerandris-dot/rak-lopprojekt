
#!/bin/bash
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
apt update -y && apt install libguestfs-tools -y
virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent
qm create 8001 --name "ubuntu-2204-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 8001 jammy-server-cloudimg-amd64.img ssd-data
qm set 8001 --scsihw virtio-scsi-pci --scsi0 ssd-data:vm-8001-disk-0
qm set 8001 --boot c --bootdisk scsi0
qm set 8001 --ide2 ssd-data:cloudinit
qm set 8001 --agent enabled=1
qm template 8001