# greetings_ci

Configuration management and deployment pipeline for Greetings microservice

### Description

Infrastructure as code stack for Greetings microservice:
https://github.com/maplebird/greetings_src

Designed to work with AWS.

Allows the following:

- Provision an Auto-Scaling Group for dev, test, demo, and prod environments
- Upload code to an S3 bucket for each environment so nodes can install it during a deploy or bootstrap
- Deploy new code to an environment without re-provisioning an ASG (Upload new build first)
- Run unit tests against a local copy of a server

### Upload Code to S3

Use the upload_code_to_s3.sh script with the ENV argument and an optional BRANCH argument.

If branch is not defined, it uploads default branch for the environment (master for dev and test, production for demo and prod).

Example:

```
# Upload master branch to test
./upload_code_to_s3.sh test
```

```
# Upload release_1.1 branch to production
./upload_code_to_s3.sh prod release_1.1
```

### Launch an ASG

Use ./launch_environment.sh script with an optional ENV argument.  If environment is not defined, will launch an ASG for DEV.

Example:

```
# Launch the demo environment
./launch_environment.sh demo
```

Modify ASG options like instance type, number of nodes, etc, in group_vars/all.yml
To increase number of nodes per ASG (i.e. to have 3 nodes in prod), need to modify both asg_max_capacity and asg_desired_capacity variable for the environment

Also change asg_iam_ec2_role variable for your AWS account's IAM role

Note: This requires your AWS account to be already provisioned with the following:

1. Default VPC with route tables, etc
2. Security group GreetingsPublic that allows inbound TCP ports 22 and 8080
3. IAM role for instances
4. An ec2 SSH key already created.  Define ssh_key_name with the name of your SSH key.

### Run Deploy

Upload code to the S3 bucket first, then run ./deploy.sh

Make sure your AWS ec2 SSH key is in /root/greetings.pem or modify ansible_ssh_private_key_file variable to point to your ec2 ssh key

```
# Deploy release_1.1 branch to production
./upload_code_to_s3.sh prod release_1.1
./deploy.sh prod
```

### Run Unit tests

Run the unit test shell script, optionally specifying the branch (default runs against master).
Requires npm and Python 2.7 installed.

```
# Run against master
./unittest.sh

# Run against specific branch
./unittest.sh production
```