# lsblk
## List all block devices
```bash
root@kxwang:/home/kxwang# lsblk
NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda       8:0    0    50G  0 disk 
├─sda1    8:1    0   512M  0 part /boot/efi
├─sda2    8:2    0     1K  0 part 
└─sda5    8:5    0  49.5G  0 part /
sr0      11:0    1  1024M  0 rom  
nvme0n1 259:0    0     8G  0 disk 
```
## List all zoned block devices
```bash
root@kxwang:/home/kxwang# lsblk -z
NAME    ZONED
sda     none
├─sda1  none
├─sda2  none
└─sda5  none
sr0     none
nvme0n1 host-managed
```
## Display block device name,size, and zone model
```bash
root@kxwang:/home/kxwang# lsblk -o NAME,SIZE,ZONED
NAME      SIZE ZONED
sda        50G none
├─sda1    512M none
├─sda2      1K none
└─sda5   49.5G none
sr0      1024M none
nvme0n1     8G host-managed
```
# blkzone
## Zone report
```bash
root@kxwang:/home/kxwang# blkzone report /dev/nvme0n1
  start: 0x000000000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000020000, len 0x020000, wptr 0x0005c8 reset:0 non-seq:0, zcond: 2(oi) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000040000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000060000, len 0x020000, wptr 0x000060 reset:0 non-seq:0, zcond: 2(oi) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000080000, len 0x020000, wptr 0x000018 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x0000a0000, len 0x020000, wptr 0xfffffffffff5fff8 reset:0 non-seq:0, zcond:14(fu) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x0000c0000, len 0x020000, wptr 0xfffffffffff3fff8 reset:0 non-seq:0, zcond:14(fu) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x0000e0000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000100000, len 0x020000, wptr 0xffffffffffeffff8 reset:0 non-seq:0, zcond:14(fu) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000120000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000140000, len 0x020000, wptr 0x01c168 reset:0 non-seq:0, zcond: 2(oi) [type: 2(SEQ_WRITE_REQUIRED)]
  ...
  start: 0x000fa0000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000fc0000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000fe0000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
```
- **Restrict the report to a or a range of zoned**
```bash
root@kxwang:/home/kxwang# blkzone report --offset 0x000c80000 --count 1 /dev/nvme0n1
  start: 0x000c80000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
root@kxwang:/home/kxwang# blkzone report --offset 0x000c80000 --count 2 /dev/nvme0n1
  start: 0x000c80000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
  start: 0x000ca0000, len 0x020000, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
```
## Zone Restet
```bash
root@kxwang:/home/kxwang# blkzone reset --offset 0x000c80000 --count 2 /dev/nvme0n1
root@kxwang:/home/kxwang# blkzone reset --offset 0x000c80000 --count 1 /dev/nvme0n1
```
