#checkov:skip=CKV_DOCKER_3: "Ensure that a user for the container has been created"
#GitHub actions require that the docker image use the root user
#https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions#user

FROM ubuntu:24.04 AS install-ccs

#################################
### Install Required Packages ###
#################################
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get --yes upgrade && \
    apt-get install --yes --no-install-recommends apt-utils=2.8.3 \
                                                  autoconf=2.71-3 \
                                                  bash=5.2.21-2ubuntu4 \
                                                  build-essential=12.10ubuntu1 \
                                                  curl=8.5.0-2ubuntu10.6 \
                                                  git=1:2.43.0-1ubuntu7.3 \
                                                  libc6-i386=2.39-0ubuntu8.6 \
                                                  libtool=2.4.7-7build1 \
                                                  software-properties-common=0.99.49.3 \
                                                  unzip=6.0-28ubuntu4.1 \
                                                  wget=1.21.4-1ubuntu4.1 && \
    rm -rf /var/lib/apt/lists/*



############################
### Create Download area ###
############################    
RUN mkdir /root/Downloads



###################
### Install CCS ###
###################
ENV INSTALLER_URL=https://software-dl.ti.com/ccs/esd/CCSv11/CCS_11_0_0/exports/CCS11.0.0.00012_web_linux-x64.tar.gz
ENV INSTALLER_TAR=CCS11.0.0.00012_web_linux-x64.tar.gz
ENV INSTALLER_PATH=ccs_setup_11.0.0.00012.run

#  download and run CCS installer
RUN curl -L ${INSTALLER_URL} --output /root/Downloads/${INSTALLER_TAR} --silent && \
    tar xf /root/Downloads/${INSTALLER_TAR} --directory /root/Downloads/ && \
    chmod +x /root/Downloads/${INSTALLER_PATH} && \
    /root/Downloads/${INSTALLER_PATH} --mode unattended --enable-components PF_MSP430 --prefix /opt/ti && \
    mkdir -p /home/build/workspace


FROM ghcr.io/apollo-fire/ccs-base:v11.0.0 as install-specific-cgt
ARG MSP430_CGT_VERSION
ARG MSP430_CGT_INSTALLER_URL

############################################
### Install MSP430 Code Generation Tools ###
############################################
ENV TI_CGT_INSTALLER_URL=https://software-dl.ti.com/codegen/esd/cgt_public_sw/MSP430/${MSP430_CGT_INSTALLER_URL}
ENV TI_CGT_INSTALLER=ti_cgt_msp430_installer.bin

RUN curl -L ${TI_CGT_INSTALLER_URL} --output /root/Downloads/${TI_CGT_INSTALLER} --silent && \
    chmod +x /root/Downloads/${TI_CGT_INSTALLER} && \
    /root/Downloads/${TI_CGT_INSTALLER} --prefix /opt/ti/ccs/tools/compiler --unattendedmodeui minimal && \
    /opt/ti/ccs/eclipse/eclipse -noSplash -data /home/build/workspace -application com.ti.common.core.initialize -ccs.productDiscoveryPath "/opt/ti/" -ccs.toolDiscoveryPath "/opt/ti/ccs/tools/compiler" && \
    git config --system --add safe.directory "*"



#############################################################################
### Pre build the small code / small data version of the MSP430 libraries ###
#############################################################################
# Saves ~6 mins per build
ENV PATH="/opt/ti/ccs/eclipse:${PATH}"
ENV PATH="/opt/ti/ccs/tools/compiler/ti-cgt-msp430_${MSP430_CGT_VERSION}/bin:${PATH}"
WORKDIR /opt/ti/ccs/tools/compiler/ti-cgt-msp430_${MSP430_CGT_VERSION}/lib
RUN ./mklib --pattern=rts430x_sc_sd_eabi.lib



###################################################
### Remove the previously created download area ###
###################################################
RUN rm -rf /root/Downloads/



###############################################
### Configure container execution behaviour ###
###############################################
CMD ["/bin/bash"]

# Copy the script used to build a CCS project to the filesystem path `/` of the container
COPY build_project.sh /build_project.sh

# Code file to execute when the docker container starts up (`build_project.sh`)
ENTRYPOINT ["/build_project.sh"]

# The health check should be improved in the future once we identify characteristics to test
HEALTHCHECK CMD exit 0


# See the comment at the top of the file as to why these suppressions are necessary.
#checkov:skip=CKV_DOCKER_8: "GitHub actions require that the docker image use the root user"
# hadolint global ignore=DL3002
# Trivy requires suppressions to be linked to an actual resource, in this case the following explicit `USER` command.
#trivy:ignore:AVD-DS-0002
USER root
