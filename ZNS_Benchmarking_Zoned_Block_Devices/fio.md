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

**Before Write**
```bash
root@kxwang:/home/kxwang# zbd report /dev/nullb0 
Zone 00000: cnv, ofst 00000000000000, len 00000067108864, cap 00000067108864
Zone 00001: cnv, ofst 00000067108864, len 00000067108864, cap 00000067108864
Zone 00002: cnv, ofst 00000134217728, len 00000067108864, cap 00000067108864
Zone 00003: cnv, ofst 00000201326592, len 00000067108864, cap 00000067108864
Zone 00004: swr, ofst 00000268435456, len 00000067108864, cap 00000067108864, wp 00000268435456, em, non_seq 0, reset 0
Zone 00005: swr, ofst 00000335544320, len 00000067108864, cap 00000067108864, wp 00000335548416, oi, non_seq 0, reset 0
Zone 00006: swr, ofst 00000402653184, len 00000067108864, cap 00000067108864, wp 00000402653184, em, non_seq 0, reset 0
...
Zone 00052: swr, ofst 00003489660928, len 00000067108864, cap 00000067108864, wp 00003489660928, em, non_seq 0, reset 0
Zone 00053: swr, ofst 00003556769792, len 00000067108864, cap 00000067108864, wp 00003556769792, em, non_seq 0, reset 0
```
**Fio write**

*For zoned block device, figure out starting LBA of first sequential zone, use this as --offset for fio.*

```bash
root@kxwang:/home/kxwang# fio --name=zns-fio-seq --filename=/dev/nullb0 --direct=1 --zonemode=zbd --offset=00000335544320 --size=1G --ioengine=libaio --iodepth=8 --rw=write --bs=256k --allow_mounted_write=1
zns-fio-seq: (g=0): rw=write, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T) 256KiB-256KiB, ioengine=libaio, iodepth=8
fio-3.16
Starting 1 process

zns-fio-seq: (groupid=0, jobs=1): err= 0: pid=2297: Tue May 24 23:38:16 2022
  write: IOPS=11.0k, BW=2996MiB/s (3141MB/s)(704MiB/235msec); 1 zone resets
    slat (usec): min=3, max=243, avg=14.25, stdev=35.75
    clat (usec): min=55, max=3066, avg=650.64, stdev=404.50
     lat (usec): min=60, max=3071, avg=664.97, stdev=413.76
    clat percentiles (usec):
     |  1.00th=[  180],  5.00th=[  206], 10.00th=[  208], 20.00th=[  210],
     | 30.00th=[  219], 40.00th=[  371], 50.00th=[  783], 60.00th=[  840],
     | 70.00th=[  898], 80.00th=[  971], 90.00th=[ 1090], 95.00th=[ 1303],
     | 99.00th=[ 1582], 99.50th=[ 1778], 99.90th=[ 2606], 99.95th=[ 2769],
     | 99.99th=[ 3064]
  lat (usec)   : 100=0.57%, 250=35.37%, 500=6.25%, 750=5.18%, 1000=35.16%
  lat (msec)   : 2=17.22%, 4=0.25%
  cpu          : usr=2.99%, sys=8.55%, ctx=3026, majf=0, minf=12
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=99.8%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,2816,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
  WRITE: bw=2996MiB/s (3141MB/s), 2996MiB/s-2996MiB/s (3141MB/s-3141MB/s), io=704MiB (738MB), run=235-235msec

Disk stats (read/write):
  nullb0: ios=0/3475, merge=0/0, ticks=0/2710, in_queue=2711, util=60.16%
```

**After Write**
Report Zone Info
```bash
root@kxwang:/home/kxwang# zbd report /dev/nullb0 
Zone 00000: cnv, ofst 00000000000000, len 00000067108864, cap 00000067108864
Zone 00001: cnv, ofst 00000067108864, len 00000067108864, cap 00000067108864
Zone 00002: cnv, ofst 00000134217728, len 00000067108864, cap 00000067108864
Zone 00003: cnv, ofst 00000201326592, len 00000067108864, cap 00000067108864
Zone 00004: swr, ofst 00000268435456, len 00000067108864, cap 00000067108864, wp 00000268435456, em, non_seq 0, reset 0
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

...
Zone 00052: swr, ofst 00003489660928, len 00000067108864, cap 00000067108864, wp 00003489660928, em, non_seq 0, reset 0
Zone 00053: swr, ofst 00003556769792, len 00000067108864, cap 00000067108864, wp 00003556769792, em, non_seq 0, reset 0
```
*With the disk in this state, executing the same command again without the zbd zone mode enabled, fio will attempt to write to full zones, resulting in I/O errors.*
```bash
root@kxwang:/home/kxwang# fio --name=zns-fio-seq --filename=/dev/nullb0 --direct=1  --size=1G --ioengine=libaio --iodepth=8 --rw=write --bs=256k --allow_mounted_write=1
zns-fio-seq: (g=0): rw=write, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T) 256KiB-256KiB, ioengine=libaio, iodepth=8
fio-3.16
Starting 1 process
fio: io_u error on file /dev/nullb0: Input/output error: write offset=335544320, buflen=262144
fio: pid=14693, err=5/file:io_u.c:1787, func=io_u error, error=Input/output error

zns-fio-seq: (groupid=0, jobs=1): err= 5 (file:io_u.c:1787, func=io_u error, error=Input/output error): pid=14693: Thu May 26 19:47:09 2022
  write: IOPS=7005, BW=1740MiB/s (1825MB/s)(319MiB/183msec); 0 zone resets
    slat (usec): min=3, max=387, avg=55.38, stdev=72.89
    clat (usec): min=99, max=2965, avg=1070.30, stdev=302.83
     lat (usec): min=154, max=2970, avg=1126.08, stdev=307.46
    clat percentiles (usec):
     |  1.00th=[  330],  5.00th=[  709], 10.00th=[  775], 20.00th=[  832],
     | 30.00th=[  881], 40.00th=[  963], 50.00th=[ 1057], 60.00th=[ 1139],
     | 70.00th=[ 1205], 80.00th=[ 1270], 90.00th=[ 1401], 95.00th=[ 1532],
     | 99.00th=[ 2089], 99.50th=[ 2540], 99.90th=[ 2868], 99.95th=[ 2966],
     | 99.99th=[ 2966]
  lat (usec)   : 100=0.08%, 250=0.55%, 500=1.33%, 750=5.85%, 1000=36.43%
  lat (msec)   : 2=54.06%, 4=1.09%
  cpu          : usr=6.04%, sys=1.65%, ctx=1765, majf=0, minf=23
  IO depths    : 1=0.1%, 2=0.2%, 4=0.3%, 8=99.5%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1282,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
  WRITE: bw=1740MiB/s (1825MB/s), 1740MiB/s-1740MiB/s (1825MB/s-1825MB/s), io=319MiB (334MB), run=183-183msec

Disk stats (read/write):
  nullb0: ios=0/3846, merge=0/0, ticks=0/2747, in_queue=2747, util=53.56%
```
*With the zbd zone mode enabled, the same command executed again with the zones full succeeds.*
```bash
root@kxwang:/home/kxwang# fio --name=zns-fio-seq --filename=/dev/nullb0 --direct=1 --zonemode=zbd --offset=00000335544320 --size=1G --ioengine=libaio --iodepth=8 --rw=write --bs=256k --allow_mounted_write=1
zns-fio-seq: (g=0): rw=write, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T) 256KiB-256KiB, ioengine=libaio, iodepth=8
fio-3.16
Starting 1 process

zns-fio-seq: (groupid=0, jobs=1): err= 0: pid=15083: Thu May 26 21:42:32 2022
  write: IOPS=33.5k, BW=8381MiB/s (8788MB/s)(704MiB/84msec); 11 zone resets
    slat (usec): min=3, max=243, avg=28.68, stdev=16.66
    clat (nsec): min=1252, max=1227.2k, avg=204628.04, stdev=106043.66
     lat (usec): min=26, max=1379, avg=233.42, stdev=119.45
    clat percentiles (usec):
     |  1.00th=[   68],  5.00th=[  167], 10.00th=[  169], 20.00th=[  172],
     | 30.00th=[  174], 40.00th=[  176], 50.00th=[  178], 60.00th=[  188],
     | 70.00th=[  217], 80.00th=[  221], 90.00th=[  227], 95.00th=[  245],
     | 99.00th=[  955], 99.50th=[  988], 99.90th=[ 1156], 99.95th=[ 1172],
     | 99.99th=[ 1221]
  lat (usec)   : 2=0.04%, 4=0.36%, 50=0.36%, 100=0.75%, 250=93.96%
  lat (usec)   : 500=2.45%, 750=0.53%, 1000=1.35%
  lat (msec)   : 2=0.21%
  cpu          : usr=8.43%, sys=15.66%, ctx=5614, majf=0, minf=15
  IO depths    : 1=0.4%, 2=0.8%, 4=1.6%, 8=97.3%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,2816,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
  WRITE: bw=8381MiB/s (8788MB/s), 8381MiB/s-8381MiB/s (8788MB/s-8788MB/s), io=704MiB (738MB), run=84-84msec

Disk stats (read/write):
  nullb0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
```
**Note that fio output in this case indicates the number of zones that were reset prior to writing.**
