# lsscsi
## Install lssci
```bash
# dnf install lsscsi
```
## Identify Host Managed Disks
```bash
root@kxwang:/home/kxwang# lsscsi
[0:0:0:0]    disk    ATA      QEMU HARDDISK    2.5+  /dev/sda 
[1:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     2.5+  /dev/sr0 
[N:0:0:1]    disk    QEMU NVMe Ctrl__1                          /dev/nvme0n1
```
## Disk Interface and Transport
```bash
oot@kxwang:/home/kxwang# lsscsi -t
[0:0:0:0]    disk    ata:ATA     QEMU HARDDISK                           QM00001               /dev/sda 
[1:0:0:0]    cd/dvd  ata:ATA     QEMU DVD-ROM                            QM00003               /dev/sr0 
[N:0:0:1]    disk    pcie 0x1af4:0x1100                         /dev/nvme0n1
```
