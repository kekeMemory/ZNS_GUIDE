# Install libzbd
```bash
$ git clone https://github.com/westerndigitalcorporation/libzbd.git
$ sudo apt install -y autoconf automake libtool m4 autoconf-archive
$ cd libzbd
$ sh ./autogen.sh
$ ./configure
$ make -j$(nproc)
$ sudo make install
```
The library files are by default installed under /usr/lib (or /usr/lib64). The library header file is installed under /usr/include/libzbd.
The executable files for the example applications are installed under /usr/bin.

# Libaray Function
