## QEMU Setting

 sudo apt install -y ninja-build pkg-config libglib2.0-dev libpixman-1-dev
 wget https://download.qemu.org/qemu-6.2.0.tar.xz
 tar xvJf qemu-6.2.0.tar.xz
 cd qemu-6.2.0
 ./configure
 make -j$(nproc)
 sudo make install

