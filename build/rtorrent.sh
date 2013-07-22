#!/bin/sh

output_dir=/app

indent() {
  sed -u 's/^/       /'
}

set -e

export PATH=$PATH:$output_dir/bin
export PKG_CONFIG_PATH=/usr/lib/pkgconfig

echo '----> Installing XMLRPC-C'
curl -Lso - http://sourceforge.net/projects/xmlrpc-c/files/Xmlrpc-c%20Super%20Stable/1.25.24/xmlrpc-c-1.25.24.tgz/download | tar xzf -
cd xmlrpc-c-1.25.24
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1  indent && make install 2>&1 | indent
cd ..

echo '----> Installing libsigc++2.2'
curl -Lso - http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.4.tar.gz | tar xzf -
cd libsigc++-2.2.4
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..

export sigc_LIBS="-L$output_dir/lib"
export sigc_CFLAGS="-I$output_dir/include/sigc++-2.0 -I$output_dir/lib/sigc++-2.0/include -I$output_dir/include"

echo '----> Installing libTorrent'
curl -Lso - http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.3.tar.gz | tar xzf -
cd libtorrent-0.13.3
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..

echo '----> Installing rTorrent'
export libtorrent_CFLAGS="-I$output_dir/include"
export libtorrent_LIBS="-L$output_dir/lib"
# export LDFLAGS="-L$output_dir/lib"
# export CPPFLAGS="-I$output_dir/include"

curl -Lso - http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.3.tar.gz | tar xzf -
cd rtorrent-0.9.3
./configure --prefix=$output_dir --with-xmlrpc-c=$output_dir/bin/xmlrpc-c-config 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
