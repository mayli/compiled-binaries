#!/bin/sh

output_dir=/app

indent() {
  sed -u 's/^/       /'
}

set -e

echo "\$output_dir=output_dir"

export PATH=$PATH:$output_dir/bin

echo '--> Installing LibEvent'
curl -L https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz -s -o - | tar xzf -
cd libevent-2.0.21-stable
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent

cd ..

export LIBEVENT_CFLAGS="-I$output_dir/include"
export LIBEVENT_LIBS="-L$output_dir/lib"

echo '--> Installing XML Parser'
curl -s -L http://cpanmin.us | perl - -l ~/perl5 App::cpanminus local::lib && eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib` && cpanm -n XML::Parser

echo '--> Installing Gettext'
curl -Ls ftp://ftp.gnu.org/gnu/gettext/gettext-0.18.2.1.tar.gz -o - | tar xzf -
cd gettext-0.18.2.1
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..

echo '--> Installing intltool'
curl -L https://launchpad.net/intltool/trunk/0.50.2/+download/intltool-0.50.2.tar.gz -s -o - | tar xzf -
cd intltool-0.50.2
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..

export LDFLAGS="-L$output_dir/lib -levent -ldl"

echo '--> Installing Transmission'
curl -LO http://download.transmissionbt.com/files/transmission-2.80.tar.xz -s
tar xf transmission-2.80.tar.xz
cd transmission-2.80
./configure --prefix=$output_dir 2>&1 | indent
make 2>&1 | indent && make install 2>&1 | indent
cd ..
