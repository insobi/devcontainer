FROM ubuntu:focal

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

ENV VERSION_TERRAFORM=1.0.0 \
    VERSION_ANSIBLE=2.9.13 \
    VERSION_TF_PROVIDER_ACI=0.7.0 \
    VERSION_ANSIBLE_ACI=2.0.0 \
    VERSION_ANSIBLE_NXOS=2.3.0

RUN echo "Installing python3 and packages -->" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends python3 python3-pip python3-setuptools

RUN echo "Installing common utils -->" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends wget unzip curl tree git ssh

RUN echo "Installing Terraform ${VERSION_TERRAFORM} -->"  \
    && curl -sSL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${VERSION_TERRAFORM}/terraform_${VERSION_TERRAFORM}_linux_amd64.zip 2>&1 \
    && unzip -d /usr/bin /tmp/terraform.zip \
    && chmod +x /usr/bin/terraform \
    && mkdir -p /root/.terraform.cache/plugin-cache \
    && rm -f /tmp/terraform.zip \
    && terraform -install-autocomplete

RUN echo "Installing Ansible ${VERSION_ANSIBLE} -->" \
    && pip3 install --no-cache-dir ansible==${VERSION_ANSIBLE} \
    && pip3 install jmespath

# Terraform Provider - ciscodevnet/aci
RUN echo "Installing Terraform Provider: Cisco ACI ${VERSION_TF_PROVIDER_ACI} -->"  \
    && curl -sSL -o /tmp/tf_aci.zip https://releases.hashicorp.com/terraform-provider-aci/${VERSION_TF_PROVIDER_ACI}/terraform-provider-aci_${VERSION_TF_PROVIDER_ACI}_linux_amd64.zip 2>&1 \
    && mkdir -p /root/.terraform.d/plugins/registry.terraform.io/ciscodevnet/aci/${VERSION_TF_PROVIDER_ACI}/linux_amd64 \
    && unzip -d /root/.terraform.d/plugins/registry.terraform.io/ciscodevnet/aci/${VERSION_TF_PROVIDER_ACI}/linux_amd64 /tmp/tf_aci.zip \
    && rm -f /tmp/tf_aci.zip

# Ansible Collections
RUN echo "Installing Ansible collections -->" \ 
    && ansible-galaxy collection install cisco.aci:==${VERSION_ANSIBLE_ACI} \
    && ansible-galaxy collection install cisco.nxos:==${VERSION_ANSIBLE_NXOS}

# MS Excel file handler
RUN echo "Installing python packages -->" \ 
    && pip3 install openpyxl pandas paramiko