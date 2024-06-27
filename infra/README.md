## Infra Code for Custom CDN Blog

Blog Link: https://kunalsin9h.com/blog/content-delivery-network

Login with Azure

```bash
az login
```

> `az` is Azures CLI

After loging in

Plan the infra

```bash
terraform plan
```

and apply

```bash
terraform apply
```

This is give ip address to all the vms created

Check the outputs 

```bash
terraform output
```

After working destroy the infra

```bash
terraform destroy
```