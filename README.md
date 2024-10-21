# Create bucket s3 with name random asigned

## Create a bucket, upload  the bucket file.zip , create a user group, create a application codedeploy and  asign tags.

1.-create variable file `archivo.tfvars`

```
acces_key   = ""
secret_key  = ""
region_aws  = ""
bucket_name = ""
key_object_zip=""
source_objet_local = ""
name_codedeploy_application = ""
compute_platform_name=""
deployment_group_name_codedeploy =""
deployment_type=""
codedeploy_role_name =""

```

## Comand

```
* terraform init
* terraform plan
* terraform apply
```

Modify script when name spesific required
