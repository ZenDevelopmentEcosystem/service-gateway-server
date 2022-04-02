FROM ubuntu:22.04

LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

LABEL description="Service Gateway Server, \
A SSHd proxy server to be placed on the Internet \
that allows trusted clients to expose private service \
ports to those authorized to use the gateway."

EXPOSE 10022

USER ssh
