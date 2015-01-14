#!/bin/bash
ssh-keygen -t rsa -b 4096
touch ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
