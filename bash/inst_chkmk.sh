#!/bin/bash
wget http://mathias-kettner.com/download/check-mk-agent_1.2.4p3-2_all.deb
wget http://mathias-kettner.com/download/check-mk-agent-logwatch_1.2.4p3-2_all.deb
sudo dpkg -i check-mk-agent_1.2.4p3-2_all.deb
sudo dpkg -i check-mk-agent-logwatch_1.2.4p3-2_all.deb
sudo apt-get install xinetd
echo "Installation Complete"
