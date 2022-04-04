FROM ubuntu:22.04

LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

LABEL description="Service Gateway Server, \
A SSHd proxy server to be placed on the Internet \
that allows trusted clients to expose private service \
ports to those authorized to use the gateway."

ENV DEBIAN_FRONTEND noninteractive

# ---- SSH Server ----
RUN mkdir -p /run/sshd
RUN \
    apt-get update \
    && apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"  install --no-install-recommends \
        openssh-server \
        net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=400 --chown=root:root app/config/sshd_config /etc/ssh/
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


# ---- Users ----
RUN \
    useradd --home-dir /home/client --create-home --user-group client \
    && useradd --home-dir /home/access --create-home --user-group access

# ---- Service Gateway ----
RUN \
    mkdir -p /opt/servicegwd/bin \
    && mkdir -p /etc/servicegwd/ \
    && touch /etc/servicegwd/authorized_keys \
    chmod 555 /etc/servicegwd/authorized_keys

COPY --chmod=755 app/bin /opt/servicegwd/bin

ENV PATH="/opt/servicegwd/bin:${PATH}"

EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-e", "-D", "-f", "/etc/ssh/sshd_config"]
HEALTHCHECK CMD /bin/netstat -nl | grep 0.0.0.0:22 | grep LISTEN
