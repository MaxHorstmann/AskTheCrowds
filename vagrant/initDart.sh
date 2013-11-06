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
  unzip $ARCHIVE
fi

mkdir -p /opt/atc
cd /opt/atc

ARCHIVE2=master.zip
if [ -e $ARCHIVE2 ]
then
  rm $ARCHIVE2
fi

if [ -e AskTheCrowdsServer-master ]
then
  rm -rf AskTheCrowdsServer-master
fi

echo "Pulling latest AskTheCrowds from github ..."
wget https://github.com/MaxHorstmann/AskTheCrowdsServer/archive/$ARCHIVE2
unzip $ARCHIVE2

/opt/dart/dart/dart-sdk/bin/dart
