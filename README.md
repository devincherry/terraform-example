# terraform
Infrastructure as code

## Overview
This terraform repo is intended to be reusable for any number of environments, whether for work, or for personal projects. The goal is to create a templatic terraform repo, which allows for provisioning of inexpensive dev environments, with the ability to scale those environments horizontally into multiple _VPCs_, _regions_, and _availability zones_ by exposing a number of modifiable variables to each _stack_.

### Modules
Several modules are included within this repo. The primary ones are listed below, along with a description of their intended purpose.

* `aws-vpc` - This module provides the scalable network foundation for an AWS-based project. See `aws-vpc/inputs.tf` for available variables and usage explanations. By default, this module should create a single VPC, with non-redundant public and private subnets, and some basic security groups to help enforce secure access patterns between instances and other resources.
* `demoapp-stack` - This module provides a template for creating a server stack. The idea is to define all resources for a given SaaS stack within a similarly structured module, such that you can provision multiple copies of that SaaS stack as-needed (e.g. one for dev, staging, and prod respectively).

### Files
A couple terraform files are provided for either configuring your environment-specific settings, or for use as templates/examples for further customization. Key files are listed below:

* `settings.tf.DIST` - This is a template, which should be copied to `settings.tf` (or similar) and modified for your specific needs. Some default values are defined to help you along your way.
* `dev-environment.tf` - This file is intended to define an initial development environment, complete with an `aws-vpc`, and an example `demoapp-stack`. Modify as-needed.
* `providers.tf` - This file is used to define and configure your terraform providers, such as the `aws` provider. Modify as-needed.

## Usage
First, you'll need to copy `settings.tf.DIST` to a new file `my-settings.tf`. Edit the file as-needed, to use your own AWS credentials, and to specify your desired region and any other settings you'd like to change.

Then, modify `dev-environment.tf` if desired, to create your own custom network and server stack.

Finally, run `terraform plan` to see how your environment will be provisioned.

## Disclaimer
This repo is provided as-is, with no warranty, either express or implied. Any costs or damages are the sole responsibility of the user. If you use any of the code, configurations, or example in this repo, you're expected to read and understand everything fully before making use of it.

