FROM debian:10.6

RUN apt-get clean \
	&& apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get -y install wget apt-transport-https ca-certificates \
	&& wget -O - https://repo.jotta.us/public.gpg | apt-key add - \
	&& echo "deb https://repo.jotta.us/debian debian main" | tee /etc/apt/sources.list.d/jotta-cli.list \
	&& apt-get update -y \
	&& apt-get install jotta-cli -y \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/lists/*

ENTRYPOINT [ "./entrypoint.sh" ]
