bearer="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
runner_name="gh-worker-linux"
owner="your github username here"
repo="your repo name here"

## References ##
# https://github.com/actions/runner/blob/main/docs/automate.md
# https://docs.github.com/en/actions/security-guides/automatic-token-authentication

# Reg Token
TOKEN=$(curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $bearer"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$owner/$repo/actions/runners/registration-token \
  | jq -r .token)

echo $TOKEN

# List Runners
ID=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $bearer"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$owner/$repo/actions/runners \
  | jq -M -j ".runners | .[] | select(.name == \"${runner_name}\") | .id")

echo $ID

# Add Runner
adduser --disabled-password --gecos "" runner
mkdir -p /apps; cd /apps; mkdir actions-runner && cd actions-runner; chown runner:nogroup /apps -R; chmod 777 /apps -R
su runner
curl -o actions-runner-linux-x64-2.301.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.301.1/actions-runner-linux-x64-2.301.1.tar.gz
tar xzf ./actions-runner-linux-x64-2.301.1.tar.gz
./config.sh --url https://github.com/$owner/$repo --token $TOKEN
./run.sh

# Delete Runner
curl \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $bearer"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/chrisreeves-/reeves-infra/actions/runners/$ID

echo "Or ... from the runner"

./config.sh remove --token $TOKEN