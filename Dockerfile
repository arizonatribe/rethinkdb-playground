FROM arizonatribe/centosnodesupervisor 
MAINTAINER David Nunez <arizonatribe@gmail.com>

# Add RethinkDb repo and install it
RUN wget http://download.rethinkdb.com/centos/7/`uname -m`/rethinkdb.repo \
          -O /etc/yum.repos.d/rethinkdb.repo
RUN yum install rethinkdb -y

COPY docker /

WORKDIR /data/rethinkdb-playground
# This is the only file outside the app/ and docker/ directories needing to be copied over
COPY package.json /data/rethinkdb-playground/
# Web application files (server and client)
COPY ./src /data/rethinkdb-playground

# Execute the chain of build steps outlined in the scripts block of package.json
RUN cd /data/rethinkdb-playground && npm install --production

RUN chown -R rethinkdb:rethinkdb /data/rethinkdb-playground

# TODO : See if there is a way to get rethinkdb running off its config file instead
#ENTRYPOINT ["/etc/init.d/rethinkdb", "start"]
#ENTRYPOINT ["/usr/bin/rethinkdb", "--bind", "all", "--directory", "/data/rethinkdb-playground/db", "--log-file", "/data/rethinkdb-playground/log/rethinkdb.log"]

EXPOSE 28015 29015 8080
ENV SERVER_NAME rethinkdb1
CMD ["/usr/bin/start"]
