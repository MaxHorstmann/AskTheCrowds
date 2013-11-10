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


echo "Starting AskTheCrowds server..."
cd AskTheCrowdsServer-master/src/AskTheCrowdsServer
/opt/dart/dart/dart-sdk/bin/pub get
/opt/dart/dart/dart-sdk/bin/dart /opt/atc/AskTheCrowdsServer-master/src/AskTheCrowdsServer/bin/askthecrowdsserver.dart


