if [ "$(stat --format "%Y" "${JIRA_INSTALL}/conf/server.xml")" -eq "0" ]; then
  if [ -n "${X_PROXY_NAME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8082"]' --type "attr" --name "proxyName" --value "${X_PROXY_NAME}" "${JIRA_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_PORT}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8082"]' --type "attr" --name "proxyPort" --value "${X_PROXY_PORT}" "${JIRA_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_SCHEME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8082"]' --type "attr" --name "scheme" --value "${X_PROXY_SCHEME}" "${JIRA_INSTALL}/conf/server.xml"
  fi
  if [ "${X_PROXY_SCHEME}" = "https" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8082"]' --type "attr" --name "secure" --value "true" "${JIRA_INSTALL}/conf/server.xml"
    xmlstarlet ed --inplace --pf --ps --update '//Connector[@port="8082"]/@redirectPort' --value "${X_PROXY_PORT}" "${JIRA_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PATH}" ]; then
    xmlstarlet ed --inplace --pf --ps --update '//Context/@path' --value "${X_PATH}" "${JIRA_INSTALL}/conf/server.xml"
  fi
fi
exec "$@"
