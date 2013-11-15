#!/bin/bash
apt-get install -y unzip

mkdir -p /opt/dart
cd /opt/dart

ARCHIVE=darteditor-linux-x64.zip

if [ ! -e $ARCHIVE ]
then
  echo "Acquiring Dart ..."
  wget -q http://storage.googleapis.com/dart-archive/channels/stable/release/latest/editor/$ARCHIVE
fi

if [ ! -d dart ]
then
  unzip -q $ARCHIVE
fi

cp -f /vagrant/atc-server.conf /etc/init 
cp -f /opt/dart/dart/dart-sdk/bin/dart /usr/bin



