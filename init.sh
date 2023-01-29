PROJECT_ID=$1
REGION=$2
echo $PROJECT_ID
gcloud config set project $PROJECT_ID
gsutil mb -p $PROJECT_ID -l $REGION -b on gs://$PROJECT_ID-terraform-state
terraform init -backend-config="bucket=$PROJECT_ID-terraform-state"