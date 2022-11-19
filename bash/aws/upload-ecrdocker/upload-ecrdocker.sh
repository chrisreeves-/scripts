awsid=""
awsregion="ap-southeast-2"
imagename=""
ecrrepo=""

docker tag $imagename $awsid.dkr.ecr.$awsregion.amazonaws.com/$ecrrepo
aws ecr get-login-password | docker login --username AWS --password-stdin $awsid.dkr.ecr.$awsregion.amazonaws.com
docker build -t $imagename .
docker tag $imagename $awsid.dkr.ecr.$awsregion.amazonaws.com/$ecrrepo
docker push $awsid.dkr.ecr.$awsregion.amazonaws.com/$ecrrepo

# Test Image
#docker run $awsid.dkr.ecr.$awsregion.amazonaws.com/$ecrrepo