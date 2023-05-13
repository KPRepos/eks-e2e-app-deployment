#!/bin/bash

# Define your desired bucket name prefix and region
BUCKET_NAME_PREFIX="terraform-state-bucket"
REGION=$1

# Get the AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Create the S3 bucket with versioning enabled and AWS account ID appended to the name
BUCKET_NAME="${BUCKET_NAME_PREFIX}-${AWS_ACCOUNT_ID}-${REGION}"

## If loop added per notes and guidance from "https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html" on LocationConstraint
if [ "$REGION" == "us-east-1" ]; then
  aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --acl private
else
  aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION \
    --acl private
fi

aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration MFADelete=Disabled,Status=Enabled

OS="$(uname)"

if [ "$OS" == "Darwin" ]; then
  echo "Running commands for macOS"
      
      # Update the backend.tf file with the new bucket name
    sed -i  '' "s/bucket_name/$BUCKET_NAME/g" provider-backend.tf
    sed -i  '' "s/region_name/$REGION/g"  provider-backend.tf
    sed -i  '' "s/region_name/$REGION/g"   lab-variables.auto.tfvars
    
    sed -i  '' "s/bucket-name/$BUCKET_NAME/g" ./cicd/data-aws.tf
    
    sed -i  '' "s/bucket_name/$BUCKET_NAME/g" ./cicd/provider-backend.tf
    sed -i  '' "s/region_name/$REGION/g"  ./cicd/provider-backend.tf
    sed -i  '' "s/region_name/$REGION/g"  ./cicd/lab-variables.auto.tfvars
    echo "updated Bucket and region info in files provider-backend.tf, lab-variables.auto.tfvars, ./cicd/data-aws.tf, ./cicd/provider-backend.tf and ./cicd/lab-variables.auto.tfvars"
elif [ "$OS" == "Linux" ]; then
  echo "Running commands for Linux"

    # Update the backend.tf file with the new bucket name
    sed -i "s/bucket_name/$BUCKET_NAME/g" provider-backend.tf
    sed -i "s/region_name/$REGION/g"  provider-backend.tf
    sed -i "s/region_name/$REGION/g"   lab-variables.auto.tfvars
    
    sed -i "s/bucket_name/$BUCKET_NAME/g" ./cicd/data-aws.tf
    
    sed -i "s/bucket_name/$BUCKET_NAME/g" ./cicd/provider-backend.tf
    sed -i "s/region_name/$REGION/g"  ./cicd/provider-backend.tf
    sed -i "s/region_name/$REGION/g"  ./cicd/lab-variables.auto.tfvars

    echo "updated Bucket and region info in files provider-backend.tf, lab-variables.auto.tfvars, ./cicd/data-aws.tf, ./cicd/provider-backend.tf and ./cicd/lab-variables.auto.tfvars"

else
  echo "Unsupported OS: $OS"
fi


