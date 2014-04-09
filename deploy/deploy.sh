sudo rm -rf AskTheCrowds
git clone git@github.com:MaxHorstmann/AskTheCrowds.git
sudo stop atc-server
sudo rm -rf /opt/atc-server/*
sudo cp -r AskTheCrowds/src/Server/* /opt/atc-server/
sudo /opt/dart/dart/dart-sdk/bin/pub get
sudo start atc-server
