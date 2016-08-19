## Version: 0.5
FROM ubuntu:16.04
MAINTAINER Adolfo De Unánue Tiscareño "adolfo.deunanue@itam.mx"

ENV REFRESHED_AT 2016-08-19

## No queremos que sea interactivo
ENV DEBIAN-FRONTEND noninteractive

## Variables para el usuario
ENV ITAM_USER itam
ENV ITAM_UID 1000

## Actualizamos
RUN apt-get -qq update

## Instalamos el software necesario
RUN apt-get -y --no-install-recommends install tmux zsh build-essential git curl autotools-dev autoconf automake pkg-config \
    libncurses5-dev libevent-dev cowsay bc tree rsync libtool \
    language-pack-en language-pack-es make gcc zlib1g-dev git python python-dev python-setuptools \
    python-pip python-simplejson jq libzmq3-dev sqlite3 libsqlite3-dev pandoc libcurl4-openssl-dev \
    nodejs libblas-dev liblapack-dev gfortran libfreetype6-dev libpng-dev wget make npm gawk \
    gcc libxml2-dev libxslt1-dev software-properties-common aspell aspell-es aspell-en ispell ispanish man-db openssh-client

## Agregamos el repositorio de GNU/Emacs
RUN apt-add-repository ppa:ubuntu-elisp/ppa && \
    apt-get -qq update && \
    apt-get -y install emacs-snapshot

## Usamos como emacs la versión snapshot
RUN update-alternatives --set emacs /usr/bin/emacs-snapshot

RUN echo "es_MX.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen es_MX.utf8 \
    && /usr/sbin/update-locale LANG=es_MX.UTF-8


## Instalamos GNU parallel
RUN (wget -O - pi.dk/3 || curl pi.dk/3/ || fetch -o - http://pi.dk/3) | bash

## Reconfiguramos
RUN dpkg-reconfigure locales

## Creamos el usuario itam
## El password es itam (así en minúsculas)
## Generado con openssl passwd -salt itam itam
RUN useradd -m -s /bin/zsh -d /home/$ITAM_USER -N -u $ITAM_UID $ITAM_USER \
    -p itOo7XYSbU3nw && \
    mkdir /home/$ITAM_USER/proyectos && \
    mkdir /home/$ITAM_USER/.local && \
    mkdir /home/$ITAM_USER/.jupyter && \
    chown -R $ITAM_USER:users /home/$ITAM_USER && \
    chown -R root:users /opt

## Lo agregamos a sudoers
RUN adduser $ITAM_USER sudo

WORKDIR /home/$ITAM_USER

## Forzamos que el shell del usuario sea zsh
RUN chsh -s /bin/zsh $ITAM_USER

## Permisos de escritura al grupo en /opt
RUN chmod -R g+w /opt

## Cambiamos al usuario itam
USER $ITAM_USER

## Instalamos Oh-my-ZSH
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

## Ejecutamos la consola
CMD ["/bin/zsh"]
