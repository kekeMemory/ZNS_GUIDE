#!
sudo ./blktrace -d /dev/sda -a issue  | ./blkparse sda -f "%5T.%9t %p %C  %a %3d %S %N \n"  -a write -o /home/kathy/Documents/problktrace/1301.txt
