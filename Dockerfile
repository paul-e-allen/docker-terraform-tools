FROM python:3.11

LABEL org.opencontainers.image.description="Terraform and related tools in a container"

ARG DEBIAN_FRONTEND=noninteractive
ARG CONTAINER_USER_NAME=ec2-user
ARG CONTAINER_USER_ID=1000
ARG CONTAINER_GROUP_ID=1000
ARG CONTAINER_GROUP_NAME=ec2-user

# ENV TZ=America/New_York

RUN apt-get clean && apt-get update && apt-get -qy upgrade \
    && apt-get -qy install locales tzdata apt-utils software-properties-common build-essential python3 nano graphviz \
    && locale-gen en_US.UTF-8 \
    && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get -qy install nano dnsutils jq sudo

# clean up after ourselves, keep image as lean as possible
RUN apt-get remove -qy --purge software-properties-common \
    && apt-get autoclean -qy \
    && apt-get autoremove -qy --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# python updates/packages
RUN pip3 install --upgrade --root-user-action=ignore boto3 botocore pip

# aws CLI v2
RUN curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm -rf awscliv2.zip

# tfenv and terraform
ENV TFENV_VERSION=3.0.0
RUN mkdir -p /opt/tfenv \
	&& git clone https://github.com/tfutils/tfenv.git --branch v${TFENV_VERSION} /opt/tfenv \
	&& ln -s /opt/tfenv/bin/* /usr/bin \
	&& tfenv install latest \
    && tfenv use latest \
	&& chmod -R a+w /opt/tfenv/versions /opt/tfenv/version

RUN addgroup --gid $CONTAINER_GROUP_ID $CONTAINER_USER_NAME
RUN adduser --disabled-password --gecos '' --uid $CONTAINER_USER_ID --gid $CONTAINER_GROUP_ID $CONTAINER_USER_NAME
RUN echo "$CONTAINER_USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN usermod --append --groups sudo $CONTAINER_USER_NAME

USER ${CONTAINER_USER_NAME}
RUN mkdir ~/.ssh && \
	ssh-keyscan github.com >> ~/.ssh/known_hosts

# Aliases for humans using the container
COPY bashrc-extras.sh /tmp/bashrc-extras.sh
RUN cat /tmp/bashrc-extras.sh >> ~/.bashrc

CMD [ "/bin/bash" ]
