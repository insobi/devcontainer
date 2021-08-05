FROM ubuntu:bionic

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN echo "Install Linux packages --->" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install wget unzip curl tree git ssh gawk sshpass software-properties-common --yes \
    && apt-get install build-essential checkinstall --yes \
    && apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev --yes

ENV VERSION_PYTHON=3.9.6
RUN echo "Install Python ${VERSION_PYTHON} --->" \
    && curl -sSL -o /tmp/python.tgz https://www.python.org/ftp/python/${VERSION_PYTHON}/Python-${VERSION_PYTHON}.tgz \
    && tar xvfz /tmp/python.tgz -C /tmp/ \
    && cd /tmp/Python-${VERSION_PYTHON} \
    && ./configure --enable-optimizations \
    && make altinstall \
    && update-alternatives --install /usr/bin/python python /usr/local/bin/python3.9 1

RUN echo "Install Python PIP --->"\
    && curl -sSl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py \
    && python /tmp/get-pip.py

ENV VERSION_ANSIBLE=4.3.0
RUN echo "Installing Ansible ${VERSION_ANSIBLE} -->" \
    && pip3 install --no-cache-dir ansible==4.3.0 \
    && pip3 install jmespath \
    && pip3 install ansible-lint

ENV VERSION_TERRAFORM=1.0.0
RUN echo "Installing Terraform ${VERSION_TERRAFORM} -->"  \
    && apt update && apt install --yes unzip curl \
    && curl -sSL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${VERSION_TERRAFORM}/terraform_${VERSION_TERRAFORM}_linux_amd64.zip 2>&1 \
    && unzip -d /usr/bin /tmp/terraform.zip \
    && chmod +x /usr/bin/terraform \
    && mkdir -p /root/.terraform.cache/plugin-cache \
    && rm -f /tmp/terraform.zip \
    && terraform -install-autocomplete

ENV VERSION_TF_PROVIDER_ACI=0.7.1
RUN echo "Installing Terraform Provider: Cisco ACI ${VERSION_TF_PROVIDER_ACI} -->"  \
    && curl -sSL -o /tmp/tf_aci.zip https://releases.hashicorp.com/terraform-provider-aci/${VERSION_TF_PROVIDER_ACI}/terraform-provider-aci_${VERSION_TF_PROVIDER_ACI}_linux_amd64.zip 2>&1 \
    && mkdir -p /root/.terraform.d/plugins/registry.terraform.io/ciscodevnet/aci/${VERSION_TF_PROVIDER_ACI}/linux_amd64 \
    && unzip -d /root/.terraform.d/plugins/registry.terraform.io/ciscodevnet/aci/${VERSION_TF_PROVIDER_ACI}/linux_amd64 /tmp/tf_aci.zip \
    && rm -f /tmp/tf_aci.zip

RUN echo "Installing kubectl --->" \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN echo "Installing Helm --> " \
    && apt update \
    && apt-get install apt-transport-https gnupg --yes \
    && curl https://baltocdn.com/helm/signing.asc | apt-key add - \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install helm -y


ENV VERSION_ANSIBLE_ACI=2.0.0
RUN echo "Installing Ansible collection - ACI ${VERSION_ANSIBLE_ACI} -->" \ 
    && ansible-galaxy collection install cisco.aci:==${VERSION_ANSIBLE_ACI}

# ENV VERSION_ANSIBLE_NXOS=2.3.0
# RUN echo "Installing Ansible collection - NXOS ${VERSION_ANSIBLE_NXOS} -->" \ 
#     && ansible-galaxy collection install cisco.nxos:==${VERSION_ANSIBLE_NXOS}

RUN echo "Installing python modules -->" \ 
    && pip3 install openpyxl pandas

# RUN pip3 install pip --upgrade \
#     && pip3 install cryptography \
#     && pip3 install paramiko