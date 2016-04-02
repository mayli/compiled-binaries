#!/bin/sh

set -e

# Ubuntu build packages
# sudo apt-get install subversion build-essential libtool automake openssl libsigc++-2.0-dev libncurses5-dev libncursesw5-dev libcurl4-openssl-dev libcppunit-dev


output_dir=/tmp/app

indent() {
  sed -u 's/^/       /'
}

set -o errexit

export PATH=$PATH:$output_dir/bin
export PKG_CONFIG_PATH=$output_dir/lib/pkgconfig

echo '----> Installing libcurl'
curl https://curl.haxx.se/download/curl-7.48.0.tar.gz | tar xzf -
cd curl-7.48.0
./configure --prefix=/tmp/app --disable-smb --disable-ftp --disable-file --disable-ldap --disable-dict --disable-telnet --disable-tftp --disable-rtsp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-ares --disable-debug --without-zlib --without-libidn --build=i586-pc-linux-gnu --host=i386-pc-mingw32 --disable-shared --disable-ipv6 --without-librtmp --without-ssl
make 2>&1 | indent && make install 2>&1 | indent
cd ..

echo '----> Installing XMLRPC-C'
curl -Lso - http://sourceforge.net/projects/xmlrpc-c/files/Xmlrpc-c%20Super%20Stable/1.25.24/xmlrpc-c-1.25.24.tgz/download | tar xzf -
cd xmlrpc-c-1.25.24
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..

echo '----> Installing libsigc++2.2'
curl -Lso - http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.10.tar.bz2 | tar xjf -
cd libsigc++-2.2.10
./configure --prefix=$output_dir --enable-static --disable-shared 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..

# export sigc_LIBS="-L$output_dir/lib"
# export sigc_CFLAGS="-I$output_dir/include/sigc++-2.0 -I$output_dir/lib/sigc++-2.0/include -I$output_dir/include"

echo '----> Installing libTorrent'
curl -Lso - https://github.com/rakshasa/libtorrent/archive/0.13.6.tar.gz | tar xzf -
cd libtorrent-0.13.6 && ./autogen.sh
./configure --prefix=$output_dir --enable-static --disable-shared 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..

echo '----> Installing rTorrent'
# export libtorrent_CFLAGS="-I$output_dir/include"
# export libtorrent_LIBS="-L$output_dir/lib"
# export LDFLAGS="-L$output_dir/lib"
# export CPPFLAGS="-I$output_dir/include"

curl -Lso - https://github.com/rakshasa/rtorrent/archive/0.9.6.tar.gz | tar xzf -
cd rtorrent-0.9.6 && ./autogen.sh
./configure --prefix=$output_dir --with-xmlrpc-c=$output_dir/bin/xmlrpc-c-config 2>&1 | indent
make SHARED=0 CXX="g++ -static" 2>&1 | indent && make install 2>&1 | indent
cd ..

# Build static binary
# cd rtorrent-0.9.6/src
# g++ -static -g -O2 -g -DDEBUG -pthread -DCURL_STATICLIB -I$output_dir/include -o rtorrent main.o  libsub_root.a ui/libsub_ui.a core/libsub_core.a display/libsub_display.a input/libsub_input.a rpc/libsub_rpc.a utils/libsub_utils.a -L$output_dir/lib $output_dir/lib/libcurl.a $output_dir/lib/libtorrent.a -L/usr/lib -lz -lxmlrpc_server -lxmlrpc -lxmlrpc_util -lxmlrpc_xmlparse -lxmlrpc_xmltok -pthread -Wl,-Bdynamic -dl -lcrypto -lncursesw
