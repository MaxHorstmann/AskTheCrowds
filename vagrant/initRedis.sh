#!/bin/bash
service iptables stop

REDIS=redis-2.6.13

mkdir -p /opt/redis/bin

ARCHIVE=$REDIS.tar.gz

cd /opt/redis

if [ ! -e $ARCHIVE ]
then
  echo "Acquiring redis source..."
  wget -q http://redis.googlecode.com/files/$ARCHIVE
fi

if [ ! -d $REDIS ]
then
  tar xzf $ARCHIVE
fi

cd $REDIS

echo "Building redis (if necessary)..."
make --quiet > /dev/null 2>&1

cp src/redis-server /opt/redis/bin/redis-server
cp src/redis-cli /opt/redis/bin/redis-cli

cp /vagrant/redis.init.d /etc/init.d/redis
cp /vagrant/redis.conf /etc/redis.conf

if ! id redis > /dev/null 2>&1
then
  useradd redis
fi

/etc/init.d/redis start
