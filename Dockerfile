FROM ubuntu
RUN apt-get update && apt-get install -y wget unzip git bash curl ca-certificates dumb-init nano
RUN apt install -y default-jre
RUN apt install -y default-jdk
# Install the server
RUN wget -O /gremlin.zip http://mirrors.estointernet.in/apache/tinkerpop/3.4.2/apache-tinkerpop-gremlin-server-3.4.2-bin.zip && \
	unzip /gremlin.zip -d /gremlin && \
	rm /gremlin.zip
WORKDIR /gremlin/apache-tinkerpop-gremlin-server-3.4.2

# Place where the graph is saved, see gremlin-graph.properties
RUN mkdir /graph_file

# Configure gremlin for python
RUN bin/gremlin-server.sh install org.apache.tinkerpop gremlin-python 3.4.2

EXPOSE 8182

# Copy the configuration files
COPY files .

# Use the dumb-init init system to correctly forward shutdown signals to gremlin-server
ENTRYPOINT ["/usr/bin/dumb-init", "--rewrite", "15:2",  "--"]

# Launch
RUN chmod 700 startup_commands.sh
CMD ["./startup_commands.sh"]
