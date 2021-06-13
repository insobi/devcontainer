FROM ubuntu:focal

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN echo "Installing python3..." \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install python3 python3-pip python3-setuptools

RUN echo "Installing common utils -->" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends wget unzip curl tree git

RUN echo "Installing dnac sdk ..." \
    && pip3 install requests dnacentersdk