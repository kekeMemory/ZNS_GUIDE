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
./zenfs mkfs --force --zbd=$DEV --aux_path=<path to store LOG and LOCK files>


./db_bench \
    --fs_uri=zenfs://dev:$DEV \
    --key_size=16 \
    --value_size=800 \
    --benchmarks=fillrandom,overwrite
    --use_direct_io_for_flush_and_compaction \
```
- List files within a ZenFS file system
```
root@kxwang:/home/kxwang/rocksdb# ./zenfs list --zbd=/nvme0n1
        4096	May 20 2022 17:19:36            rocksdbtest                     
root@kxwang:/home/kxwang/rocksdb# ./zenfs list --zbd=/nvme0n1 --path=rocksdbtest
        4096	May 20 2022 17:19:36            dbbench                         
root@kxwang:/home/kxwang/rocksdb# ./zenfs list --zbd=/nvme0n1 --path=rocksdbtest/dbbench
           0	May 20 2022 17:19:36            LOCK                            
       51972	May 20 2022 17:19:37            LOG                             
    34749985	May 20 2022 17:19:36            000009.sst                      
    34738954	May 20 2022 17:19:36            000011.sst                      
    67460938	May 20 2022 17:19:37            000017.sst                      
    34737902	May 20 2022 17:19:37            000018.sst                      
    55413721	May 20 2022 17:19:37            000020.sst                      
    34756437	May 20 2022 17:19:37            000021.sst                      
    65011216	May 20 2022 17:19:37            000022.log                      
    34790409	May 20 2022 17:19:37            000023.sst                      
    65011216	May 20 2022 17:19:37            000024.log                      
    34759854	May 20 2022 17:19:37            000025.sst                      
           0	May 20 2022 17:19:37            000026.log                      
          16	May 20 2022 17:19:36            CURRENT                         
          36	May 20 2022 17:19:36            IDENTITY                        
        1115	May 20 2022 17:19:37            MANIFEST-000004                 
        6631	May 20 2022 17:19:36            OPTIONS-000007                  
```
