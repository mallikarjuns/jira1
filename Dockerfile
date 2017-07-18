FROM openjdk:8
ENV JIRA_HOME /var/atlassian/application-data/jira
ENV JIRA_INSTALL /opt/atlassian/jira
ENV JIRA_VERSION 7.3.6
RUN set -x \
&& echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list \
&& apt-get update --quiet \
&& apt-get install --quiet --yes --no-install-recommends xmlstarlet \
&& apt-get install --quiet --yes --no-install-recommends -t jessie-backports libtcnative-1 \
&& apt-get clean \
&& mkdir -p "${JIRA_HOME}" \
&& mkdir -p "${JIRA_HOME}/caches/indexes" \
&& chmod -R 700 "${JIRA_HOME}" \
&& chown -R daemon:daemon "${JIRA_HOME}" \
&& mkdir -p "${JIRA_INSTALL}/conf/Catalina" \
&& curl -Ls "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-core-${JIRA_VERSION}.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
&& curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
&& rm -f "${JIRA_INSTALL}/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar" \
&& curl -Ls "https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar" -o "${JIRA_INSTALL}/lib/postgresql-9.4.1212.jar" \
&& chmod -R 700 "${JIRA_INSTALL}/conf" \
&& chmod -R 700 "${JIRA_INSTALL}/logs" \
&& chmod -R 700 "${JIRA_INSTALL}/temp" \
&& chmod -R 700 "${JIRA_INSTALL}/work" \
&& chown -R daemon:daemon "${JIRA_INSTALL}/conf" \
&& chown -R daemon:daemon "${JIRA_INSTALL}/logs" \
&& chown -R daemon:daemon "${JIRA_INSTALL}/temp" \
&& chown -R daemon:daemon "${JIRA_INSTALL}/work" \
&& sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
&& echo -e "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
&& touch -d "@0" "${JIRA_INSTALL}/conf/server.xml"
VOLUME ["/var/atlassian/application-data/jira", "/opt/atlassian/jira/logs"]
WORKDIR /opt/atlassian/jira
ADD build/server.xml /opt/atlassian/jira/conf
COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN chmod +x /docker-entrypoint.sh
EXPOSE 8082
