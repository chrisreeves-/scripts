#!/bin/bash
/etc/init.d/bind9 stop
cd /etc/bind/zones
echo Checking Zone Files
named-checkzone bugoutbag.co.nz.db /etc/bind/zones/bugoutbag.co.nz.db
named-checkzone cableski.co.nz /etc/bind/zones/cableski.co.nz.db
named-checkzone chrisreeves.co.nz /etc/bind/zones/chrisreeves.co.nz.db
named-checkzone darwinntjobs.com /etc/bind/zones/darwinntjobs.com.db
named-checkzone extremeit.co.nz /etc/bind/zones/extremeit.co.nz.db
named-checkzone gobag.co.nz /etc/bind/zones/gobag.co.nz.db
named-checkzone haas.co.nz /etc/bind/zones/haas.co.nz.db
named-checkzone iphone5g.co.nz /etc/bind/zones/iphone5g.co.nz.db
named-checkzone itrecruitment.co.nz /etc/bind/zones/itrecruitment.co.nz.db
named-checkzone jetpacks.co.nz /etc/bind/zones/jetpacks.co.nz.db
named-checkzone payasyougo.co.nz /etc/bind/zones/payasyougo.co.nz.db
named-checkzone renthotdesk.co.nz /etc/bind/zones/renthotdesk.co.nz.db
named-checkzone siri.co.nz /etc/bind/zones/siri.co.nz.db
named-checkzone softwareasservice.co.nz /etc/bind/zones/softwareasservice.co.nz.db
named-checkzone vds.co.nz /etc/bind/zones/vds.co.nz.db
named-checkzone virtualprivateserver.co.nz.db /etc/bind/zones/virtualprivateserver.co.nz.db
named-checkzone virtualprivateserver.net.nz.db /etc/bind/zones/virtualprivateserver.net.nz.db
named-checkzone virtualprivateservers.net.nz.db /etc/bind/zones/virtualprivateservers.net.nz.db
named-checkzone vpserver.co.nz.db /etc/bind/zones/vpserver.co.nz.db
named-checkzone vpshosting.co.nz.db /etc/bind/zones/vpshosting.co.nz.db
echo Starting Bind9
/etc/init.d/bind9 start
echo Reloading rndc
rndc reload
