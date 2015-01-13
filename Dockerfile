# Version: 0.0.2
FROM ubuntu:14.10
MAINTAINER Adolfo De Unánue Tiscareño "adolfo.deunanue@itam.mx"

# Actualizamos
RUN apt-get -qq update

# Instalamos el software necesario
RUN apt-get -y install tmux zsh build-essential git emacs24 curl autotools-dev automake pkg-config libncurses5-dev libevent-dev
RUN apt-get -y install language-pack-en language-pack-es make gcc zlib1g-dev git python python-dev python-pip libzmq3-dev sqlite3 libsqlite3-dev pandoc libcurl4-openssl-dev nodejs libblas-dev liblapack-dev gfortran libfreetype6-dev libpng-dev wget make gcc libxml2-dev libxslt-dev software-properties-common

#RUN  add-apt-repository ppa:cassou/emacs

#RUN apt-get update

#RUN apt-get install emacs24

RUN echo "es_MX.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen es_MX.utf8 \
    && /usr/sbin/update-locale LANG=es_MX.UTF-8


# Reconfiguramos
RUN dpkg-reconfigure locales



# Creamos el usuario itam
RUN useradd -d /home/itam -p JXFBFm7Klstpw -m -s /bin/zsh itam
WORKDIR /home/itam
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~itam/.oh-my-zsh
RUN cp ~itam/.oh-my-zsh/templates/zshrc.zsh-template ~itam/.zshrc
RUN chsh -s /bin/zsh itam

# Cambiamos al usuario itam
USER itam

# Emacs Prelude
RUN curl -L http://git.io/epre | sh
