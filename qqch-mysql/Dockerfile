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
RUN apt-get install -y mysql-server

# Install munin plugins
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_bin_relay_log
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_commands
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_connections
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_files_tables
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_bpool
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_bpool_act
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_insert_buf
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_io
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_io_pend
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_log
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_rows
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_semaphores
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_innodb_tnx
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_myisam_indexes
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_network_traffic
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_qcache
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_qcache_mem
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_replication
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_select_types
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_slow
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_sorts
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_table_locks
RUN ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_tmp_tables
RUN ln -s /usr/share/munin/plugins/mysql_bytes /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/mysql_innodb /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/mysql_queries /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/mysql_slowqueries /etc/munin/plugins/
RUN ln -s /usr/share/munin/plugins/mysql_threads /etc/munin/plugins/

#Fix root password issu
RUN /build/prepare_mysql.sh

EXPOSE 3306


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
