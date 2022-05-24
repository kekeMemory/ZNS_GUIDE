# fio Zoned Block Device Support
Support for zoned block devices was added to fio with version 3.9. All previous versions do not provide guarantees for write command ordering with host managed zoned block devices. Executing workloads is still possible, but requires writing complex fio scripts.
## Install fio supproted Zoned Block Device
```bash
$ git clone https://github.com/axboe/fio
$ cd fio
$ ./configure --prefix=$HOME/local
$ make
$ make install
```
## Sequential Write Workload
Use direct write I/O is mandatory for zoned block devices. 
The *zbd* zone mode, when enabled, enforces this requirement by checking that the option --direct=1 is specified for any job executing write I/Os.

The --offset and --size options must specify values that are aligned to the device zone size.
If the the disk has been mounted, allow_mounted_write should be set not to 0.

```bash
# fio --name=zns-fio-seq --filename=/dev/nullb0 --direct=1 --zonemode=zbd --offset=2097152 --size=1G --ioengine=libaio --iodepth=8 --rw=write --bs=256k --allow_mounted_write=1

zns-fio-seq: (g=0): rw=write, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T) 256KiB-256KiB, ioengine=libaio, iodepth=8
fio-3.16
Starting 1 process
/dev/nullb0: rounded up offset from 2097152 to 67108864

zns-fio-seq: (groupid=0, jobs=1): err= 0: pid=10276: Tue May 24 22:57:10 2022
  write: IOPS=20.4k, BW=5106MiB/s (5354MB/s)(960MiB/188msec); 1 zone resets
    slat (usec): min=3, max=225, avg=36.14, stdev=32.69
    clat (usec): min=44, max=1966, avg=353.52, stdev=235.62
     lat (usec): min=50, max=1972, avg=389.75, stdev=229.76
    clat percentiles (usec):
     |  1.00th=[  157],  5.00th=[  219], 10.00th=[  227], 20.00th=[  233],
     | 30.00th=[  241], 40.00th=[  285], 50.00th=[  306], 60.00th=[  310],
     | 70.00th=[  322], 80.00th=[  338], 90.00th=[  490], 95.00th=[  963],
     | 99.00th=[ 1385], 99.50th=[ 1582], 99.90th=[ 1844], 99.95th=[ 1942],
     | 99.99th=[ 1958]
  lat (usec)   : 50=0.03%, 100=0.05%, 250=32.92%, 500=57.03%, 750=1.28%
  lat (usec)   : 1000=5.34%
  lat (msec)   : 2=3.36%
  cpu          : usr=2.67%, sys=13.90%, ctx=7111, majf=0, minf=13
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=99.8%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,3840,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
  WRITE: bw=5106MiB/s (5354MB/s), 5106MiB/s-5106MiB/s (5354MB/s-5354MB/s), io=960MiB (1007MB), run=188-188msec

Disk stats (read/write):
  nullb0: ios=0/10457, merge=0/0, ticks=0/266, in_queue=266, util=59.92%
```
- Report Zone Info
```bash
root@kxwang:/home/kxwang# zbd report /dev/nullb0 
Zone 00000: cnv, ofst 00000000000000, len 00000067108864, cap 00000067108864
Zone 00001: cnv, ofst 00000067108864, len 00000067108864, cap 00000067108864
Zone 00002: cnv, ofst 00000134217728, len 00000067108864, cap 00000067108864
Zone 00003: cnv, ofst 00000201326592, len 00000067108864, cap 00000067108864
Zone 00004: swr, ofst 00000268435456, len 00000067108864, cap 00000067108864, wp 00000335544320, fu, non_seq 0, reset 0
Zone 00005: swr, ofst 00000335544320, len 00000067108864, cap 00000067108864, wp 00000402653184, fu, non_seq 0, reset 0
Zone 00006: swr, ofst 00000402653184, len 00000067108864, cap 00000067108864, wp 00000469762048, fu, non_seq 0, reset 0
Zone 00007: swr, ofst 00000469762048, len 00000067108864, cap 00000067108864, wp 00000536870912, fu, non_seq 0, reset 0
Zone 00008: swr, ofst 00000536870912, len 00000067108864, cap 00000067108864, wp 00000603979776, fu, non_seq 0, reset 0
Zone 00009: swr, ofst 00000603979776, len 00000067108864, cap 00000067108864, wp 00000671088640, fu, non_seq 0, reset 0
Zone 00010: swr, ofst 00000671088640, len 00000067108864, cap 00000067108864, wp 00000738197504, fu, non_seq 0, reset 0
Zone 00011: swr, ofst 00000738197504, len 00000067108864, cap 00000067108864, wp 00000805306368, fu, non_seq 0, reset 0
Zone 00012: swr, ofst 00000805306368, len 00000067108864, cap 00000067108864, wp 00000872415232, fu, non_seq 0, reset 0
Zone 00013: swr, ofst 00000872415232, len 00000067108864, cap 00000067108864, wp 00000939524096, fu, non_seq 0, reset 0
Zone 00014: swr, ofst 00000939524096, len 00000067108864, cap 00000067108864, wp 00001006632960, fu, non_seq 0, reset 0
Zone 00015: swr, ofst 00001006632960, len 00000067108864, cap 00000067108864, wp 00001073741824, fu, non_seq 0, reset 0
Zone 00016: swr, ofst 00001073741824, len 00000067108864, cap 00000067108864, wp 00001073741824, em, non_seq 0, reset 0
Zone 00017: swr, ofst 00001140850688, len 00000067108864, cap 00000067108864, wp 00001140850688, em, non_seq 0, reset 0
Zone 00018: swr, ofst 00001207959552, len 00000067108864, cap 00000067108864, wp 00001207959552, em, non_seq 0, reset 0
Zone 00019: swr, ofst 00001275068416, len 00000067108864, cap 00000067108864, wp 00001275068416, em, non_seq 0, reset 0
Zone 00020: swr, ofst 00001342177280, len 00000067108864, cap 00000067108864, wp 00001342177280, em, non_seq 0, reset 0
...
Zone 00126: swr, ofst 00008455716864, len 00000067108864, cap 00000067108864, wp 00008455716864, em, non_seq 0, reset 0
Zone 00127: swr, ofst 00008522825728, len 00000067108864, cap 00000067108864, wp 00008522825728, em, non_seq 0, reset 0
```
