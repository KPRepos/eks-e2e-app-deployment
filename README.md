# Abstract

  This code/repo deploys a standard VPC and EKS cluster with managed NodeGroup. Further, it will deploy a CICD pipeline for sample node-js application. This application is created via Docker process and uploaded to ECR and also a Helm package pushed to same ECR. At deploy stage of pipeline, the helm package is pulled to deploy the sample app in EKS.  
                                                                                                      
### Architecture Diagram 
![](eks-helm-lab.jpg)


### Steps to Deploy the code  
#### Make sure you have required toolset to execute the deployment
* Linux system to execute the code, terraform, awscli, bash environment (linux platforms)

* Since the lab environment create resources that requires elevated acess, please authenticate your shell environmnet with AWS admin access.  

* At any point, if you need to re-run, just rerun either step-1 below (or) "terraform init --reconfigure" as required, which will (re)initialize state file within already created file.)
* Clone the Repo and cd to repo root folder (Example:- `cd eks-lab/`)
#### Just in case check if startup.sh have execute permissions - chmod +x start.sh 

1) Run `sh start.sh $region` from root folder ( Example - `sh start.sh us-west-1`, This is the region where you are looking to deploy resources, you can also change eks cluster name in lab-variables.auto.tfvars in rootfolder and cicd folder, make sure to use same name in both places, if not leaving default works just fine)

2) `terraform init`

3) `terraform apply`  (validate the plan and type `yes`)  (This step takes 15 to 20 min to complete)
 
##### * Note:- Since EKS deployment takes a while, if terraform apply failed/timeout, please rerun `terraform apply` again, which will re-apply and continue with any remaining creation of resources
 
##### Now that base infra like VPC, EKS, EKS-Addons(alb controller) and Additional Security Groups were setup, lets move to cicd folder to initiate DevOps pipeline. 

4) `cd cicd/`

5) `terraform init`

6) `terraform apply`  (validate the plan and type `yes`) - At this stage the data.tf file loads remote state from s3 bucket within root folder. Though cicd stage also uses same s3 bcuket, it uses differant state file name.
This stage of apply take less than 2 minutes. 



###  Test the deployment. 

7) Navigate to code-pipeline from AWS console and check if  pipeline - "deploy-node-js-app-eks" already started. (if not started or failed for some reason, open it and click on `Release Change` and then `Release`)

 This step will take 5-10 minutes, please watch the pipeline move from build to deploy at which point the sample node-js-app will be deployed to EKS. 

8)  `aws eks update-kubeconfig --region us-west-1 --name eks-devops-lab`   (Update this command with the region you have provided in step 1 and EKS-Clsuter name if changed in *.auto.tfvars in root folder and cicd folder)

`kubectl get ingress/ingress-node-js-app -n node-js-app`

9) Above command will provide alb dns name, please copy and paste URL in browser, typically as its a new public load balancer, it will take 2-5 minutes to propogate the DNS info and you will see a hello world message like below 

Output:- `Hello World,  my host IP is: 10.2.3.4` - Refreshing the URL will change the output to display second pod IP. 



### Destroy the deployment. 

1) Run below commands to delete sample app and it's dependencies like ALB. 

`kubectl delete deployment node-js-app-deployment -n node-js-app`
`kubectl delete namespace node-js-app`

2) From cicd folder Run `terraform destroy` (validate the plan and type `yes`) 

3) Now move to root folder by running `cd..` and Run `terraform destroy` (validate the plan and type `yes`) 

4) Delete terraform state file bucket as needed from AW Console by emptying bucket and deleting all versions 



#### Modules and References used

1) https://devopscube.com/create-helm-chart/ :- For understanding about Helm Charts
2) https://github.com/terraform-aws-modules/terraform-aws-eks - (For EKS, This code was lightly modified to fit ALB, SG)
3) https://tf-eks-workshop.workshop.aws/500_eks-terraform-workshop.html ( For CICD, This code was heavily modified and rearchitected to fit Docker, ECR, and Helm into the process)
