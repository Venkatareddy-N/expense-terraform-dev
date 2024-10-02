# expense-terraform-dev
This code is completely succes, no need any chanded
bellow commands to run
1. 10-vpc
terraform apply -auto-approve

2. 20-sg
terraform apply -auto-approve

3. 30-bastion
terraform apply -auto-approve

4. 40-apps
terraform apply -auto-approve

to access website : http://venkatswan.online/

after all your work done, remove all from last to first

1. 40-apps
terraform destroy -auto-approve

2. 30-bastion
terraform destroy -auto-approve

3. 20-sg
terraform destroy -auto-approve

4. 10-vpc
terraform destroy -auto-approve