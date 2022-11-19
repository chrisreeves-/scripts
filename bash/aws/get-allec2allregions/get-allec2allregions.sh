profile="default"
for region in `aws ec2 describe-regions --profile $profile --region ap-southeast-2 --all-regions | jq -r '.Regions | .[] | .RegionName + " " + .OptInStatus'  | grep -v not-opted-in | cut -d' ' -f1`
do
     echo -e "\nListing Instances in region:'$region'..."
     aws ec2 describe-instances --profile $profile --region $region | jq '.Reservations[] | ( .Instances[] | {state: .State.Name, name: .KeyName, type: .InstanceType, key: .KeyName})'
done
