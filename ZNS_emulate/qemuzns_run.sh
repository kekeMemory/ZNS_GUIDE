#!/bin/bash

ZNS_SSD_IMG=/home/kathy/kxwang_qemu/zns.raw
SSH_PORT=2222
sudo qemu-system-x86_64     -hda /home/kathy/kxwang_qemu/sys.img     -m 20G     -smp 12     -cpu host     --enable-kvm     -device nvme,id=nvme0,serial=deadbeef,zoned.zasl=5     -drive file=${ZNS_SSD_IMG},id=nvmezns0,format=raw,if=none     -device nvme-ns,drive=nvmezns0,bus=nvme0,nsid=1,logical_block_size=4096,physical_block_size=4096,zoned=true,zoned.zone_size=64M,zoned.zone_capacity=62M,zoned.max_open=16,zoned.max_active=32,uuid=5e40ec5f-eeb6-4317-bc5e-c919796a5f79     -net user,hostfwd=tcp::${SSH_PORT}-:22     -net nic     -vnc :2
