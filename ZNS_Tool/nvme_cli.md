Zoned namespace support was added to the Linux kernel in version 5.9. The initial driver release requires the namespace to implement the "Zone Append" command in order to work with the kernel's block stack.

# Update kernel 5.9
```bash
cd /tmp
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9/amd64/linux-headers-5.9.0-050900_5.9.0-050900.202010112230_all.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9/amd64/linux-headers-5.9.0-050900-generic_5.9.0-050900.202010112230_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9/amd64/linux-image-unsigned-5.9.0-050900-generic_5.9.0-050900.202010112230_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9/amd64/linux-modules-5.9.0-050900-generic_5.9.0-050900.202010112230_amd64.deb
sudo dpkg -i *.deb
```
# Install nvme-cli
```bash
kxwang@kxwang:~$ git clone https://github.com/linux-nvme/nvme-cli
kxwang@kxwang:~$ cd nvme-cli
kxwang@kxwang:~/nvme-cli$ meson .build
kxwang@kxwang:~/nvme-cli$ meson .build
kxwang@kxwang:~/nvme-cli$ ninja -C .build
```
# ZNS-specific Commands
```bash
root@kxwang:/home/kxwang# nvme zns help
nvme-2.0
usage: nvme zns <command> [<device>] [<args>]

The '<device>' may be either an NVMe character device (ex: /dev/nvme0) or an
nvme block device (ex: /dev/nvme0n1).

Zoned Namespace Command Set

The following are all implemented sub-commands:
  list                List all NVMe devices with Zoned Namespace Command Set support
  id-ctrl             Send NVMe Identify Zoned Namespace Controller, display structure
  id-ns               Send NVMe Identify Zoned Namespace Namespace, display structure
  report-zones        Report zones associated to a Zoned Namespace
  reset-zone          Reset one or more zones
  close-zone          Close one or more zones
  finish-zone         Finishe one or more zones
  open-zone           Open one or more zones
  offline-zone        Offline one or more zones
  set-zone-desc       Attach zone descriptor extension data to a zone
  zrwa-flush-zone     Flush LBAs associated with a ZRWA to a zone.
  changed-zone-list   Retrieve the changed zone list log
  zone-mgmt-recv      Send the zone management receive command
  zone-mgmt-send      Send the zone management send command
  zone-append         Append data and metadata (if applicable) to a zone
  version             Shows the program version
  help                Display this help

See 'nvme zns help <command>' for more information on a specific command
```
# Reporting Zones
```bash
# Retreive first 10 zone descriptors
root@kxwang:/home/kxwang# nvme zns report-zones /dev/nvme0n1 -d 10
nr_zones: 128
SLBA: 0          WP: 0          Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x4000     WP: 0x4000     Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x8000     WP: 0x8000     Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0xc000     WP: 0xc000     Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x10000    WP: 0x10000    Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x14000    WP: 0x14000    Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x18000    WP: 0x18000    Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x1c000    WP: 0x1c000    Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x20000    WP: 0x20000    Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x24000    WP: 0x24000    Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   

```
# Open a Zone
```bash
root@kxwang:/home/kxwang# nvme zns open-zone /dev/nvme0n1
zns-open-zone: Success zone slba:0 nsid:1
//Check its current state
root@kxwang:/home/kxwang# nvme zns report-zones /dev/nvme0n1 -d 2
nr_zones: 128
SLBA: 0          WP: 0          Cap: 0x3e00     State: 0x30 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x4000     WP: 0x4000     Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0   

```
# Close a Zone
```bash
root@kxwang:/home/kxwang# nvme zns close-zone /dev/nvme0n1
zns-close-zone: Success, action:1 zone:0 all:0 zcapc:0 nsid:1
//Check its current state
root@kxwang:/home/kxwang# nvme zns report-zones /dev/nvme0n1 -d 2
nr_zones: 128
SLBA: 0          WP: 0          Cap: 0x3e00     State: 0x40 Type: 0x2  Attrs: 0    AttrsInfo: 0   
SLBA: 0x4000     WP: 0x4000     Cap: 0x3e00     State: 0x10 Type: 0x2  Attrs: 0    AttrsInfo: 0 
```


# Running simple W/R commad with nvme-cli
```
root@kxwang:/home/kxwang# echo "Hello ZNS" | nvme write /dev/nvme0n1 -z 4096
write: Success

root@kxwang:/home/kxwang# echo "Hello ZNS" | nvme read /dev/nvme0n1 -z 4096
Hello ZNS
read: Success
```
# Zone Append
- Append "Hello ZNS" to the first zone block (4k in here)
```bash
root@kxwang:/home/kxwang# echo "Hello ZNS" | nvme zns zone-append /dev/nvme0n1 -z 4096
Success appended data to LBA 0
```
- Read the data back from LBA0 to verify that it saved our data
```bash
root@kxwang:/home/kxwang# nvme read /dev/nvme0n1 -z 4096
Hello ZNS
read: Success
```
- Append more data and verify its contens
```bash
root@kxwang:/home/kxwang# echo "Append data" | nvme zns zone-append /dev/nvme0n1 -z 4096
Success appended data to LBA 1
root@kxwang:/home/kxwang# nvme read /dev/nvme0n1 -z 4096
Hello ZNS
read: Success
root@kxwang:/home/kxwang# nvme read /dev/nvme0n1 -z 4096 -s 1
Append data
read: Success
```
