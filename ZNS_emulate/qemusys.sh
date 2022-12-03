#!/bin/bash

SSH_PORT=2222
sudo qemu-system-x86_64     -boot d   -hda /home/kathy/kxwang_qemu/sys.img     -cdrom /home/kathy/kxwang_qemu/ubuntu-20.04.3-desktop-amd64.iso     -m 20G     -smp 12     -cpu host     --enable-kvm     --net user,hostfwd=tcp::${SSH_PORT}-:22     -net nic     -vnc :2
