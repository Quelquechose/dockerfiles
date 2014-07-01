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
RUN apt-get install -y  postgresql-contrib postgresql postgis libdbd-pg-perl

# Install munin plugins
RUN ln -s /usr/share/munin/plugins/postgres_autovacuum /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/postgres_bgwriter /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/postgres_cache_ /etc/munin/plugins/postgres_cache_ALL
RUN ln -s /usr/share/munin/plugins/postgres_checkpoints /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/postgres_connections_ /etc/munin/plugins/postgres_connections_ALL
RUN ln -s /usr/share/munin/plugins/postgres_connections_db /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/postgres_locks_ /etc/munin/plugins/postgres_locks_ALL
RUN ln -s /usr/share/munin/plugins/postgres_oldest_prepared_xact_ /etc/munin/plugins/postgres_oldest_prepared_xact_ALL
RUN ln -s /usr/share/munin/plugins/postgres_prepared_xacts_ /etc/munin/plugins/postgres_prepared_xacts_ALL
RUN ln -s /usr/share/munin/plugins/postgres_querylength_ /etc/munin/plugins/postgres_querylength_ALL
RUN ln -s /usr/share/munin/plugins/postgres_size_ /etc/munin/plugins/postgres_size_ALL
RUN ln -s /usr/share/munin/plugins/postgres_transactions_ /etc/munin/plugins/postgres_transactions_ALL
RUN ln -s /usr/share/munin/plugins/postgres_users /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/postgres_xlog /etc/munin/plugins/

#Fix root password issu
RUN /build/prepare_postgresql.sh

EXPOSE 5432


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
