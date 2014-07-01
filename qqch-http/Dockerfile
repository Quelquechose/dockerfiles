FROM qqch/base:latest
MAINTAINER Thierry Stiegler, thierry.stiegler@gmail.com

# Make APT non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
ENV LANGUAGE fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8

RUN update-locale LANG=fr_FR.UTF-8

# Upgrade the system to the latest version
RUN apt-get update
RUN apt-get upgrade -y

# This after the package installation so we can use the docker cache
RUN mkdir -p /build
ADD . /build
RUN /build/init/00_fixmount

# --- Starting the installation of this particular image


# Install packages needed for this image
RUN apt-get install -y nginx apache2 libapache2-mod-rpaf  apache2 apache2-utils libexpat1 ssl-cert


# Install munin plugins
RUN ln -s /usr/share/munin/plugins/apache_accesses /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/apache_processes /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/apache_volume /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/nginx_request /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/nginx_status /etc/munin/plugins/


#Fix root password issu
RUN /build/prepare_http.sh

EXPOSE 80


# --- End of particularities of this image



# Give the possibility to override any file on the system
RUN cp -R /build/overrides/. / || :

# Add services
RUN cp -R /build/runit/. /etc/service/ || :

# Add init scripts
RUN cp -R /build/init/. /etc/my_init.d/ || :

# Clean everything up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /build

CMD ["/sbin/my_init"]
