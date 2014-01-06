#!/bin/bash

sudo sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"

sudo apt-get update

sudo apt-get -y install linux-image-extra-$(uname -r)
sudo apt-get -y install lxc-docker
sudo apt-get -y install git

cd ~
git clone https://github.com/gardym/docker-gitolite.git
cd docker-gitolite
cp /tmp/id_rsa.pub .

# Wait for docker to really be running
while [ ! -f /var/run/docker.pid ]; do sleep 2; done

sudo docker build -t gitolite .
sudo docker run -d -p 2222:22 gitolite
