profile="default"
for region in `aws ec2 describe-regions --profile $profile --region ap-southeast-2 | jq -r '.Regions | .[] | .RegionName + " " + .OptInStatus'  | grep -v not-opted-in | cut -d' ' -f1`
do
     echo -e "\nListing Instances in region:'$region'..."
     aws ec2 describe-volumes --profile $profile --region $region | jq '.Volumes[] | .Tags'
done