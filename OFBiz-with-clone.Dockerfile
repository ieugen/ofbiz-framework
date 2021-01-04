FROM gradle:6.5.1-jdk8 as builder

COPY . ofbiz

RUN cd ofbiz \
  && gradle clean pullAllPluginsSource build \
  && pwd

# Docker stage 1 - copy and unpack the application
FROM adoptopenjdk:8-jre-hotspot as imgbuilder

COPY --from=builder /home/gradle/ofbiz/distributions/ofbiz.tar /tmp/ofbiz.tar

RUN mkdir -p /opt/ofbiz \
	&& tar xf /tmp/ofbiz.tar --strip 1 -C /opt/ofbiz \
	&& rm /tmp/ofbiz.tar \
	&& ls -la /opt/ofbiz \
	&& apt-get update

# Docker stage 2 - copy the unpacked application
FROM adoptopenjdk:8-jre-hotspot

WORKDIR /opt/ofbiz
COPY --from=imgbuilder /opt/ofbiz .

CMD ["/opt/ofbiz/bin/ofbiz"]


