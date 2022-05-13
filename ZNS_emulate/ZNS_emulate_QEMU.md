## QEMU Setting
 
```
sudo apt install -y ninja-build pkg-config libglib2.0-dev libpixman-1-dev
wget https://download.qemu.org/qemu-6.2.0.tar.xz
tar xvJf qemu-6.2.0.tar.xz
cd qemu-6.2.0
./configure
make -j$(nproc)
sudo make install
```

## Ubuntu Setting

- Download `wget https://releases.ubuntu.com/focal/ubuntu-20.04.3-desktop-amd64.iso`
- Image Create `qemu-img create -f qcow2 sys.img 20G`
- Istall system in boot
 ```
 #!/bin/bash

SSH_PORT=2222
sudo qemu-system-x86_64     -boot d   -hda /home/kathy/sys.img     -m 20G     -smp 12     -cpu host     --enable-kvm     --net user,hostfwd=tcp::${SSH_PORT}-:22     -net nic     -vnc :2
 ```

