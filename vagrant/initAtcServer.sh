#!/bin/bash
mkdir -p /opt/atc
cd /opt/atc

ARCHIVE2=master.zip
if [ -e $ARCHIVE2 ]
then
  rm $ARCHIVE2
fi

if [ -e /etc/init/atc-server.conf ]
then
  stop atc-server
fi


if [ -e AskTheCrowds-master ]
then
  rm -rf AskTheCrowds-master
fi

echo "Pulling latest AskTheCrowds from github ..."
wget https://github.com/MaxHorstmann/AskTheCrowds/archive/$ARCHIVE2
unzip $ARCHIVE2

cd AskTheCrowds-master/src/AskTheCrowdsServer
/opt/dart/dart/dart-sdk/bin/pub get

cp -f /vagrant/atc-server.conf /etc/init

echo "Starting AskTheCrowds server..."
start atc-server

