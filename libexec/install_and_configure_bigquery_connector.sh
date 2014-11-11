# Copyright 2013 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS-IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Downloads and installs the relevant bigquery-connector-<version>.jar.
# Also configures it for use with hadoop.

set -e

if (( ${INSTALL_BIGQUERY_CONNECTOR} )); then
  # Grab the connector jarfile, add it to installation /lib directory.
  JARNAME=$(grep -o '[^/]*\.jar' <<< ${BIGQUERY_CONNECTOR_JAR})
  LOCAL_JAR="${HADOOP_INSTALL_DIR}/lib/${JARNAME}"

  download_bd_resource "${BIGQUERY_CONNECTOR_JAR}" "${LOCAL_JAR}"

  chown hadoop:hadoop ${LOCAL_JAR}

  echo "export HADOOP_CLASSPATH=\$HADOOP_CLASSPATH:${LOCAL_JAR}" \
      >> ${HADOOP_CONF_DIR}/hadoop-env.sh

  bdconfig merge_configurations \
      --configuration_file ${HADOOP_CONF_DIR}/mapred-site.xml \
      --source_configuration_file bq-mapred-template.xml \
      --resolve_environment_variables \
      --create_if_absent \
      --noclobber

  chown -R hadoop:hadoop ${HADOOP_CONF_DIR}
fi
