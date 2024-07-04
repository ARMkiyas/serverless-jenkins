# Use the official Jenkins LTS image with Alpine base
FROM jenkins/jenkins:alpine

# Argument for build ID
ARG BUILD_ID=""


# Environment variables for configuration
ENV BUILD_ID ${BUILD_ID:-'0.0.0.0-dev'}
ENV JAVA_OPTS="-Dhudson.footerURL=https://www.kiyas-cloud.live/ -Djenkins.install.runSetupWizard=false -Djenkins.telemetry.enabled=false -Dhudson.remoting.ClassFilter=java.security.KeyPair,sun.security.rsa.RSAPrivateCrtKeyImpl -Dpermissive-script-security.enabled=true -Djdk.tls.client.protocols=TLSv1.2 -javaagent:/usr/share/jenkins/jmx_prometheus_javaagent.jar=8081:/var/jenkins_home/prometheus-jmx-config.yaml -Xms3g -Xmx3g -XX:MetaspaceSize=1024m -XX:MaxMetaspaceExpansion=128m -XX:MaxMetaspaceSize=2048m -Xss2048k -XX:MaxDirectMemorySize=512m"
ENV PROMETHEUS_JMX_JAR_VERSION 0.19.0
ENV PORT ${PORT:-8080}
ENV JENKINS_HOSTNAME ${JENKINS_HOSTNAME:-"jenkins.kiyas-cloud.live"}


# Copy configuration files to container

# Copy plugins, groovy and css to container
COPY plugins.txt /var/jenkins_home/plugins.txt
COPY custom.groovy /var/jenkins_home/init.groovy.d/
COPY prometheus-jmx-config.yaml /var/jenkins_home

# # Disable plugin banner on startup
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# Switch to root user to install additional packages
USER root
# Install necessary packages and JMX Prometheus Java Agent
RUN apk --no-cache add curl graphviz && \
    curl -vSL https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${PROMETHEUS_JMX_JAR_VERSION}/jmx_prometheus_javaagent-${PROMETHEUS_JMX_JAR_VERSION}.jar -o /usr/share/jenkins/jmx_prometheus_javaagent.jar && \
    chown jenkins:jenkins -R /usr/share/jenkins && \
    chown jenkins:jenkins -R /var/jenkins_home


# Switch back to Jenkins user
USER jenkins

# Install plugins
RUN /bin/jenkins-plugin-cli --plugin-file /var/jenkins_home/plugins.txt

# Log the build ID
RUN echo ${BUILD_ID} | tee -a /tmp/build_id.txt

# Health check endpoint
HEALTHCHECK --interval=60s --timeout=10s CMD curl --fail 'http://localhost:${PORT}/login?from=login' || exit 1

# Define volumes for persistence
VOLUME ["/var/jenkins_home/logs", "/var/jenkins_home/cache"]
VOLUME ["/var/jenkins_home/jobs", "/var/jenkins_home/jenkins-jobs"]
VOLUME ["/var/jenkins_home/secrets"]


# Expose ports for Jenkins and JMX
EXPOSE ${PORT} 8081