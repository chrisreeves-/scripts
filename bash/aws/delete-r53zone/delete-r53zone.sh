domain_to_delete=DOMAINNAMEHERE
hosted_zone_id=$(
  aws route53 list-hosted-zones \
    --output text \
    --query 'HostedZones[?Name==`'$domain_to_delete'.`].Id'
)
echo hosted_zone_id=$hosted_zone_id

aws route53 list-resource-record-sets \
  --hosted-zone-id $hosted_zone_id |
jq -c '.ResourceRecordSets[]' |
while read -r resourcerecordset; do
  read -r name type <<<$(echo $(jq -r '.Name,.Type' <<<"$resourcerecordset"))
  if [ $type != "NS" -a $type != "SOA" ]; then
    aws route53 change-resource-record-sets \
      --hosted-zone-id $hosted_zone_id \
      --change-batch '{"Changes":[{"Action":"DELETE","ResourceRecordSet":
          '"$resourcerecordset"'
        }]}' \
      --output text --query 'ChangeInfo.Id'
  fi
done

aws route53 delete-hosted-zone \
  --id $hosted_zone_id \
  --output text --query 'ChangeInfo.Id'