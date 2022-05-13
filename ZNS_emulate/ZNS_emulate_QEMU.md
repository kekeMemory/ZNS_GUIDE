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
   sudo qemu-system-x86_64     -boot d   -hda /home/kathy/sys.img     -m 20G     -smp 12     -cpu host     --enable-kvm    --net user,hostfwd=tcp::${SSH_PORT}-:22     -net nic     -vnc :2
   ```
- Restart QEMU
   ```
   #!/bin/bash
   SSH_PORT=2222
   sudo qemu-system-x86_64     -boot d   -hda /home/kathy/sys.img     -cdrom /home/kathy/ubuntu-20.04.3-desktop-  amd64.iso     -m 20G     -smp 12     -cpu host     --enable-kvm     --net user,hostfwd=tcp::${SSH_PORT}-:22     -net nic     -vnc :2
   ```
- Ensure kernel version is newer than 5.10 +

## ZNS SSD EMULATE

- Create the backstore file with `dd`: `# dd if=/dev/zero of=zns.raw bs=1M count=32768`
- Start with ZNS SSD
  ```
  #!/bin/bash

  ZNS_SSD_IMG=/home/kathy/zns.raw
  SSH_PORT=2222
  sudo qemu-system-x86_64     -hda /home/kathy/sys.img     -m 20G     -smp 12     -cpu host     --enable-kvm     -device nvme,id=nvme0,serial=deadbeef,zoned.zasl=5     -drive file=${ZNS_SSD_IMG},id=nvmezns0,format=raw,if=none     -device nvme-ns,drive=nvmezns0,bus=nvme0,nsid=1,logical_block_size=4096,physical_block_size=4096,zoned=true,zoned.zone_size=64M,zoned.zone_capacity=62M,zoned.max_open=16,zoned.max_active=32,uuid=5e40ec5f-eeb6-4317-bc5e-c919796a5f79     -net user,hostfwd=tcp::${SSH_PORT}-:22     -net nic     -vnc :2
  ```



