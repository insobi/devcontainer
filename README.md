# Dockerfiles for devcontainer
This repository includes Dockerfiles for creating containers which can be used for specific development on local environment. Those devcontainer images commonly use Ubuntu 20.04 based linux environment. Devcontainers created by this Dockerfile can be found on Dockerhub. https://hub.docker.com/r/insobi/devcontainer
<br><br>

# What is a devcontainer?
Please refer to https://code.visualstudio.com/docs/remote/containers
<br><br>

# Dockerfiles
- IaC tools for Cisco ACI
  - Terraform 1.0.0
  - Terraform Provider: Ciscodevnet/aci
  - Ansible Collection: ciscodevnet/aci
  - Python 3.x
  - Etc.
- Cisco DNAC Python SDK

# troubleshoot

Resolve an error which is "qemu-x86_64: Could not open '/lib64/ld-linux-x86-64.so.2': No such file or directory" 

```
docker build --platform=linux/amd64 -t ...
```