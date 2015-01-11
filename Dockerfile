# Version: 0.0.1
FROM ubuntu:14.04
MAINTAINER Adolfo De Unánue Tiscareño "adolfo.deunanue@itam.mx"
RUN apt-get -qq update
RUN apt-get -y install tmux zsh build-essential git emacs24

