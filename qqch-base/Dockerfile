FROM phusion/baseimage:0.9.11
MAINTAINER Thierry Stiegler, thierry.stiegler@gmail.com

# Make APT non-interactive
ENV DEBIAN_FRONTEND noninteractive


# This after the package installation so we can use the docker cache
RUN mkdir /build
ADD . /build
RUN /build/init/00_fixmount
RUN cp /build/overrides/etc/apt/sources.list /etc/apt

# Upgrade the system to the latest version
RUN apt-get update
RUN apt-get upgrade -y


# --- Starting the installation of this particular image


# Install packages needed for this image


# Ensure fr_FR.UTF-8
RUN apt-get install -y locales language-pack-fr
ENV LANGUAGE fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8

RUN locale-gen fr_FR.UTF-8
RUN dpkg-reconfigure locales
RUN update-locale LANG=fr_FR.UTF-8

# Install munin
RUN apt-get install -y libcache-cache-perl libipc-sharelite-perl munin-node 


# Install Postfix.
RUN echo "postfix postfix/main_mailer_type string Internet site" > /build/preseed.txt
RUN echo "postfix postfix/mailname string mail.example.com" >> /build/preseed.txt

RUN debconf-set-selections /build/preseed.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

RUN postconf -e myhostname="acontainer.yggdrasil.quelquechose.fr"
RUN postconf -e mydestination="ks306946.kimsufi.com, yggdrasil.quelquechose.fr, localhost.localdomain, localhost"
RUN postconf -e mail_spool_directory="/var/spool/mail/"
RUN postconf -e mailbox_command=""
RUN postconf -e relayhost="172.17.42.1"

RUN ln -s /usr/share/munin/plugins/postfix_mailqueue /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/postfix_mailstats /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/postfix_mailvolume /etc/munin/plugins/

# Install basics packages
RUN apt-get install -y htop vim pwgen mailutils sudo mlocate

# Prepare image
RUN /build/prepare_base.sh

# Modify the location of the data
VOLUME ["/data"]
ENV DATA_DIR /data

EXPOSE 4949
EXPOSE 22
EXPOSE 25



# --- End of particularities of this image



# Give the possibility to override any file on the system
RUN cp -R /build/overrides/. / || :

# Add services
RUN cp -R /build/runit/. /etc/service/ || :

# Add init scripts
RUN cp -R /build/init/. /etc/my_init.d/ || :

# Clean everything up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*  /tmp/* /var/tmp/* /build

CMD ["/sbin/my_init"]
