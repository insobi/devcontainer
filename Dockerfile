FROM ubuntu:focal

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN echo "Installing common utils >>> " \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        python3 python3-pip python3-setuptools \
        wget curl tree git gawk jq iputils-ping unzip ssh sshpass \
    && ln -s /usr/bin/python3 /usr/bin/python

# MS Excel file handler - openpyxl, pandas
# Ansible json_query - jmespath
RUN echo "Installing python packages >>> " \ 
    && pip3 install \
        openpyxl pandas \
        jmespath \
        paramiko 

ENV VERSION_TERRAFORM=1.1.7
RUN echo "Installing Terraform ${VERSION_TERRAFORM} >>> "  \
    && curl -sSL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${VERSION_TERRAFORM}/terraform_${VERSION_TERRAFORM}_linux_amd64.zip 2>&1 \
    && unzip -d /usr/bin /tmp/terraform.zip \
    && chmod +x /usr/bin/terraform \
    && mkdir -p /root/.terraform.cache/plugin-cache \
    && rm -f /tmp/terraform.zip \
    && terraform -install-autocomplete

ENV VERSION_ANSIBLE=5.4.0
RUN echo "Installing Ansible ${VERSION_ANSIBLE} >>> " \
    && pip3 install --no-cache-dir ansible==${VERSION_ANSIBLE}

# Terraform Provider - CiscoDevNet/aci
ENV VERSION_TF_PROVIDER_ACI=1.2.0
RUN echo "Installing Terraform Provider: Cisco ACI ${VERSION_TF_PROVIDER_ACI} >>> " \
    && curl -sSL -o /tmp/tf_aci.zip https://releases.hashicorp.com/terraform-provider-aci/${VERSION_TF_PROVIDER_ACI}/terraform-provider-aci_${VERSION_TF_PROVIDER_ACI}_linux_amd64.zip 2>&1 \
    && mkdir -p /root/.terraform.d/plugins/registry.terraform.io/ciscodevnet/aci/${VERSION_TF_PROVIDER_ACI}/linux_amd64 \
    && unzip -d /root/.terraform.d/plugins/registry.terraform.io/ciscodevnet/aci/${VERSION_TF_PROVIDER_ACI}/linux_amd64 /tmp/tf_aci.zip \
    && rm -f /tmp/tf_aci.zip

# Ansible Collections
ENV VERSION_ANSIBLE_ACI=2.1.0
RUN echo "Installing Ansible collections >>> " \ 
    && ansible-galaxy collection install \
        cisco.aci:==${VERSION_ANSIBLE_ACI} \
        community.docker \
        community.general  

# Python packages related Ansible Collection
RUN echo "Installing python packages >>> " \ 
    && pip3 install \
        python-gitlab

RUN mkdir /etc/ansible
COPY files/ansible/ansible.cfg /etc/ansible/ansible.cfg
COPY files/ansible/hosts /etc/ansible/hosts

# kubuctl
RUN echo "Installing kubectl >>> " \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# helm
RUN echo "Installing Helm >>> " \
    && apt-get install apt-transport-https gnupg --yes \
    && curl https://baltocdn.com/helm/signing.asc | apt-key add - \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install helm --yes

# RUN echo "Installing Ansible collection - community.docker -->" \ 
#     && ansible-galaxy collection install community.docker

RUN mv /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.bak
COPY files/openssl.cnf /etc/ssl/openssl.cnf

# RUN ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
# RUN echo "" > passwd 

# RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/" /etc/ssh/sshd_config
# RUN echo "Installing sshd --> " \
#     && apt update \
#     && apt-get install openssh-server --yes

# ENV VAULT_VERSION=1.9.2
# RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O /tmp/vault.zip \
#     && unzip -d /usr/bin/ /tmp/vault.zip && rm -f /tmp/vault.zip && chmod +x /usr/bin/vault