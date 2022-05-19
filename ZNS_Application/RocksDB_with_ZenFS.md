- Building and Installing ZenFS
```bash
$ git clone https://github.com/facebook/rocksdb.git
$ cd rocksdb
$ git clone https://github.com/westerndigitalcorporation/zenfs plugin/zenfs
```
- Build and install rocksdb with zenfs enabled
```bash
$ DEBUG_LEVEL=0 ROCKSDB_PLUGINS=zenfs make -j4 db_bench install
```
- Build the zenfs utility
```bash
$ pushd
$ cd plugin/zenfs/util
$ make
$ popd
```
- Configure the IO Scheduler for the zoned block device
```bash
echo deadline > /sys/class/block/<zoned block device>/queue/scheduler
```
- Creating a ZenFS file system
    Before ZenFS can be used in RocksDB, the file system metadata and superblock must be set up. This is done with the zenfs utility, using the mkfs command:
```bash
./plugin/zenfs/util/zenfs mkfs --zbd=<zoned block device> --aux_path=<path to store LOG and LOCK files>
```
- Shell for db_bench test
```bash

#!/bin/bash

if [[ !$EUID -eq 0 ]]; then
	echo "Please run this program with super-user privileges."
	exit
fi

DEV=nvme0n1
echo deadline > /sys/class/block/$DEV/queue/scheduler

rm -rf /tmp/zenfs_$DEV
./zenfs mkfs --force --zbd=$DEV --aux_path=/tmp/zenfs_$DEV


./db_bench \
    --fs_uri=zenfs://dev:$DEV \
    --key_size=16 \
    --value_size=800 \
    --benchmarks=fillrandom,overwrite
    --use_direct_io_for_flush_and_compaction \
```
