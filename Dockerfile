FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

MAINTAINER Justin Davis

EXPOSE 8080

RUN echo $SPRING_PROFILES_ACTIVE

ENV SPRING_PROFILES_ACTIVE=dev
ENV TZ Europe/London
ENV SERVICE_GROUP_ID=org.jnd.microservices
ENV SERVICE_ARTIFACT_ID=inventory
ENV SERVICE_VERSION=0.0.1-SNAPSHOT
ENV SERVICE_PACKAGING=jar
ENV SERVICE_JAR_FILE=$SERVICE_ARTIFACT_ID-$SERVICE_VERSION.$SERVICE_PACKAGING
ENV MAVEN_VERSION 3.3.9

USER root
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

COPY settings.xml .

RUN ls -ltra

RUN mvn -B -q -s settings.xml dependency:copy \
    -DstripVersion=true \
    -Dartifact=$SERVICE_GROUP_ID:$SERVICE_ARTIFACT_ID:$SERVICE_VERSION:$SERVICE_PACKAGING \
    -DoutputDirectory=.

RUN cp $(find . -type f -name $SERVICE_ARTIFACT_ID-*.$SERVICE_PACKAGING) $SERVICE_JAR_FILE

COPY target/* .

RUN ls -ltr

RUN rm -rf /root/.m2

ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1"
USER jboss
ENTRYPOINT [ "sh", "-c", "java -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -jar $SERVICE_JAR_FILE" ]