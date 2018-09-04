# Base image
FROM library/ubuntu:18.04

# Maintainer
MAINTAINER Bernhard Schuld <u10297902@tuks.co.za>

# Updating repositories.
RUN \
apt-get clean && \
apt-get update

# Install perl
RUN apt-get install -y perl

# Install slowloris dependency
RUN apt-get install -y libwww-mechanize-shell-perl

# Set Workdir
WORKDIR /opt/slowloriax

# Get source
COPY . .

# Entrypoint
ENTRYPOINT ["sh", "entrypoint.sh"]

# Command
# CMD ["tail", "-F", "/var/log/syslog", "/var/log/cron.log"]
