#!/bin/bash

set -euxo pipefail

apt-get update -y

apt-get install -y fontconfig openjdk-21-jre wget

install -m 0755 -d /etc/apt/keyrings

wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins