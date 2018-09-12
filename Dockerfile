# Base image
FROM library/ubuntu:18.04

# Maintainer
MAINTAINER Bernhard Schuld <u10297902@tuks.co.za>

# Updating repositories.
RUN \
apt-get clean && \
apt-get update

# Install nmap
RUN apt-get install -y nmap

# Install perl
RUN apt-get install -y perl

# Install slowloris dependency
RUN apt-get install -y libwww-mechanize-shell-perl

# Install curl
RUN apt-get update && apt-get install -y curl

# Set Workdir
WORKDIR /opt/slowloriax

# Get source
COPY . .

# Entrypoint
ENTRYPOINT ["bash", "entrypoint.sh"]

# Command
# CMD ["tail", "-F", "/var/log/syslog", "/var/log/cron.log"]
