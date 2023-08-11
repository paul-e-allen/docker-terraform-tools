# Source: paul-e-allen/docker-terrafor-tools/bashrc-extras.sh
# 
# These commands are meant to be appended to a ~/.bashrc file during Docker build

alias tf=terraform
alias aws-export='eval $(aws configure export-credentials --format env)'
alias aws-id='aws sts get-caller-identity'

echo "Aliases available:"
echo "  tf              -- runs terraform"
echo "  aws-export      -- exports AWS credentials into environment variables"
echo "  aws-id          -- runs 'aws sts get-caller-identity'"

alias junk='echo "This is a junk alias"'