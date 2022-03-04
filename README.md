# Packer Ubuntu 20.04

Builds an Ubuntu 20.04 Amazon Machine Image (AMI) using [Hashicorp Packer](https://www.packer.io/docs/builders/amazon.html) with [Ansible](https://www.ansible.com/).

## Building: Prerequisites

In order to build the AMI, users will first need to have the following:

* An Amazon AWS account
* An AWS IAM user account with programmatic access (i.e., an AWS Access Key and AWS Secret Access Key).
* A role with a policy attached to the user that grants the following minimum permissions:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeyPair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:CreateLaunchTemplate",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateFleet",
                "ec2:DescribeSpotPriceHistory",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        }
    ]
}
```

## Building with Github Actions

Included in the project is the file `.github/workflows/WF_build_ami.yml`, which is used to build the AMI using Github actions.  The build does the following on the Github build server instance:
* Installs Python, Ansible, an Packer
* Validates the Packer build script
* Initializes the Packer Ansible module
* Builds the AMI

Users will need to create the following Secrets in the project Settings:
* `AWS_ACCESS_KEY_ID` - the AWS Access Key ID for the user
* `AWS_SECRET_ACCESS_KEY` - the AWS Secret Access Key for the user
* `AWS_AMI_ACCOUNTS` - a comma-delimited list of AWS accounts that the AMI will be visible to
* `AWS_OWNER` - the AWS account owner

## Building with Gitlab CI

Included in the project is the file `.gitlab-ci.yml`, which is used to build the AMI using the Gitlab CI/CD pipeline.  The build file uses the `spride/packer-ansible:1.7.10` Docker image to perform the build, so users will need to run the build using a Gitlab Docker runner.  The Docker image contains Packer and Ansible, so no extra package installs are required.  The build does the following:
* Pulls down the `spride/packer-ansible:1.7.10` image from Docker Hub (if not already pulled)
* Validates the Packer build script (via the `validate-job` stage).
* Initializes the Packer Ansible module (via the `build-job` stage).
* Builds the AMI (also in the `build-job` stage).

Users will need to create the following variables in the project:
* `AWS_ACCESS_KEY_ID` - the AWS Access Key ID for the user
* `AWS_SECRET_ACCESS_KEY` - the AWS Secret Access Key for the user
* `AWS_AMI_ACCOUNTS` - a comma-delimited list of AWS accounts that the AMI will be visible to
* `AWS_OWNER` - the AWS account owner
