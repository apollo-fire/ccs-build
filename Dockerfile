FROM ubuntu:18.04 as install-ccs

#################################
### Install Required Packages ###
#################################
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get --yes upgrade && \
    apt-get install --yes --no-install-recommends apt-utils=1.6.17 \
                                                  autoconf=2.69-11 \
                                                  bash=4.4.18-2ubuntu1.3 \
                                                  build-essential=12.4ubuntu1 \
                                                  curl=7.58.0-2ubuntu3.24 \
                                                  git=1:2.17.1-1ubuntu0.18 \
                                                  libc6-i386=2.27-3ubuntu1.6 \
                                                  libgconf-2-4=3.2.6-4ubuntu1 \
                                                  libtool=2.4.6-2 \
                                                  software-properties-common=0.96.24.32.22 \
                                                  unzip=6.0-21ubuntu1.2 \
                                                  wget=1.19.4-1ubuntu2.2 && \
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
