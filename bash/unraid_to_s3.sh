#!/bin/bash
host=unraid
bucket=CHANGEME
tmp=/mnt/user/CHANGEME

date=(`date +%d-%m-%Y`)
year=$(date +'%Y')
month=(`date +%B`)
day=(`date +%d`)
mkdir -p $tmp/unraid/$year/$month/$day

# Backup Unraid USB key
echo "Backup Unraid USB key"
tar cf - /boot -P | pv -s $(du -sb /boot | awk '{print $1}') | gzip > $tmp/unraid/$year/$month/$day/unraid-usbkey-$date.tar.gz
docker run --rm -v ~/.aws:/root/.aws -v /mnt/user/store/Backup/unraid/$year/$month/$day:/mnt/backups amazon/aws-cli s3 cp /mnt/backups/unraid-usbkey-$date.tar.gz s3://$bucket/$host/$year/$month/$day/unraid-usbkey-$date.tar.gz
aws s3api head-object --bucket $bucket --key $host/$year/$month/$day/unraid-usbkey-$date.tar.gz || not_exist=true
if [ $not_exist ]; then
  echo "Backup of Unraid USB Key Failed"
  logger "Backup of Unraid USB Key Failed" >> /var/log/syslog 
else
  echo "Backup of Unraid USB Key Successful"
  logger "Backup of Unraid USB Key Successful" >> /var/log/syslog
fi

# Backup Unraid Appdata
echo "Backup Unraid Appdata"
tar cf - /mnt/user/appdata -P | pv -s $(du -sb /mnt/user/appdata | awk '{print $1}') | gzip -9 - > $tmp/unraid/$year/$month/$day/unraid-appdata-$date.tar.gz
docker run --rm -v ~/.aws:/root/.aws -v /mnt/user/store/Backup/unraid/$year/$month/$day:/mnt/backups amazon/aws-cli s3 cp /mnt/backups/unraid-appdata-$date.tar.gz s3://$bucket/$host/$year/$month/$day/unraid-appdata-$date.tar.gz
aws s3api head-object --bucket $bucket --key $host/$year/$month/$day/unraid-appdata-$date.tar.gz || not_exist=true
if [ $not_exist ]; then
  echo "Backup of Unraid Appdata Failed"
  logger "Backup of Unraid Appdata Failed" >> /var/log/syslog 
else
  echo "Backup of Unraid Appdata Successful"
  logger "Backup of Unraid Appdata Successful" >> /var/log/syslog
fi
