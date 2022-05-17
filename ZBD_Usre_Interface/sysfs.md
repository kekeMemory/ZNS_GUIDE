- Shell scripts > ./sysfs_zoned.sh
```
#!/bin/sh

dev_name=nvme0n1

cat /sys/block/$dev_name/queue/zoned 
cat /sys/block/$dev_name/queue/chunk_sectors
cat /sys/block/$dev_name/queue/nr_zones
cat /sys/block/$dev_name/queue/zone_append_max_bytes
cat /sys/block/$dev_name/queue/max_open_zones
cat /sys/block/$dev_name/queue/max_active_zones
```
- Run scripts
```
root@kxwang:/home/kxwang# ./sysfs_zoned.sh 
host-managed
131072
128
131072
16
32
```
