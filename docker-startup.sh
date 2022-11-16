# Install a basic Debian install with no GUI, just SSH server and command line

# Make sure TCP port 22 and UDP 5121 is open on you're box.

# The script assumes the server home location is /nwn/server.

# Create the directory "/nwn/server" and subdirectories "modules", "override", "hak" and "tlk" with relevant files.

#				//PACKAGES TO INSTALL
# - install MariaDB (MySQL): apt-get -y install mariadb-server mariadb-client
# - install ruby/rubygems: apt-get install ruby
# - install the NWN library for ruby: gem install nwn-lib (may take a while)
# - apt-get install dos2unix (for converting dos line endings to unix)
# - install Docker CE (https://docs.docker.com/install/linux/docker-ce/debian/)
#
# - Other useful utilities
#   - apt-get install php php-mbstring php-xml php-mysql(for running PHP enabled websites)


#				//DATABASE SETUP
# - configuring the database as follows
#   - mysql
#   - create user 'YOUR_DB_USER'@'localhost' identified by 'YOUR_DB_PASSWORD'; [same PW below]
#   - create database YOUR_DB;
#   - GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost';
#   - /q
#   - mysql YOUR_DB < schema_mysql.sql



# - running the script below to start the server. 


cd /nwn/server
sudo systemctl reload nginx
sudo docker stop nwnxee
sudo docker rm nwnxee
sudo docker run --restart unless-stopped -dit \
    --net host -e NWN_PORT=5121 \
    --name nwnxee \
    -v $(pwd):/nwn/home \
    -e NWN_MODULE='YOUR_MODULE_NAME' \
    -e NWN_PUBLICSERVER=1 \
    -e NWN_SERVERNAME='SERVER_NAME' \
    -e NWN_NWSYNCURL=http://YOUR_IP/nwsync \
    -e NWN_NWSYNCHASH='' \
    -e NWN_PLAYERPASSWORD='' \
    -e NWN_DMPASSWORD='YOUR_DM_PASS' \
    -e NWN_ELC=0 \
    -e NWN_ILR=0 \
    -e NWN_MAXLEVEL=40 \
    -e NWN_GAMETYPE=10 \
    -e NWN_PAUSEANDPLAY=0 \
    -e NWNX_ADMINISTRATION_SKIP=n \
    -e NWNX_BEHAVIOURTREE_SKIP=y \
    -e NWNX_CHAT_SKIP=n \
    -e NWNX_CREATURE_SKIP=n \
    -e NWNX_EVENTS_SKIP=n \
    -e NWNX_DATA_SKIP=n \
    -e NWNX_METRICS_INFLUXDB_SKIP=y \
    -e NWNX_OBJECT_SKIP=n \
    -e NWNX_PLAYER_SKIP=n \
    -e NWNX_RUBY_SKIP=y \
    -e NWNX_SERVERLOGREDIRECTOR_SKIP=y \
    -e NWNX_SQL_SKIP=n \
    -e NWNX_THREADWATCHDOG_SKIP=y \
    -e NWNX_TRACKING_SKIP=n \
    -e NWNX_SQL_TYPE=mysql \
    -e NWNX_SQL_HOST=127.0.0.1 \
    -e NWNX_SQL_USERNAME='SQL_USER' \
    -e NWNX_SQL_PASSWORD='SQL_PASS' \
    -e NWNX_SQL_DATABASE='SQL_DATABASE' \
    -e NWNX_SQL_QUERY_METRICS=true \
    -e NWNX_CORE_LOG_LEVEL=7 \
    nwnxee/unified:latest

