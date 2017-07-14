FROM openjdk:8
ENV JIRA_HOME /var/atlassian/application-data/jira
ENV JIRA_INSTALL /opt/atlassian/jira
ENV JIRA_VERSION 7.3.6
RUN set -x \
&& apt-get update --quiet \
&& apt-get install --quiet --yes --no-install-recommends -t jessie-backports libtcnative-1 \
&& apt-get install -y --quiet \
&& apt-get install -y wget --quiet \
&& apt-get clean \
&& mkdir -p "${JIRA_HOME}" \
&& mkdir -p "${JIRA_HOME}/caches/indexes" \
&& chmod -R 700 "${JIRA_HOME}" \
&& mkdir -p "${JIRA_INSTALL}/conf/Catalina" \
&& curl -Ls "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-core-${JIRA_VERSION}.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
&& curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
&& sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
&& echo -e "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
&& touch -d "@0" "${JIRA_INSTALL}/conf/server.xml"
VOLUME ["/var/atlassian/application-data/jira", "/opt/atlassian/jira/logs"]
WORKDIR /opt/atlassian/jira
#ADD build/server.xml /opt/atlassian/jira/conf
COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN chmod +x /docker-entrypoint.sh
EXPOSE 8085
