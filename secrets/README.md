# Managing Secrets with Terraform <-> AWS KMS

## db-creds.yml
```
username: admin
password: password
```


## check terraform sensitive data
```bash
$ terraform output account_username
"admin"
$ terraform output account_password
"password"
```