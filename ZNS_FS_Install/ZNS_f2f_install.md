- Install f2fs-tools : `apt install f2fs-tools -y`
- `echo mq-deadline > /sys/block/nvme0n1/queue/scheduler`
- Format disk: `mkfs.f2fs -f -m -c /dev/nullb0`
- Mount: `sudp mount -t f2fs /dev/nullb0 /mnt/f2fs/`

