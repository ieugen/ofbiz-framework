#################################################################
# Docker stage - build the app using gradle
FROM gradle:6.5.1-jdk8 as builder

WORKDIR /home/gradle/ofbiz
RUN mkdir framework themes applications plugins
COPY build.gradle settings.gradle gradle.properties common.gradle .
COPY framework/base/config/component-load.xml framework/base/config/component-load.xml

RUN find .
RUN gradle --no-daemon --info --refresh-dependencies dependencies

COPY . .

RUN gradle --no-daemon --info clean build \
  && pwd


#################################################################
# Docker stage - copy and unpack the application
FROM adoptopenjdk:8-jre-hotspot as imgbuilder

COPY --from=builder /home/gradle/ofbiz/build/distributions/ofbiz.tar /tmp/ofbiz.tar

RUN mkdir -p /opt/ofbiz \
	&& tar xf /tmp/ofbiz.tar --strip 1 -C /opt/ofbiz \
	&& rm /tmp/ofbiz.tar \
	&& ls -la /opt/ofbiz


#################################################################
# Docker final stage - copy the unpacked application
#
FROM adoptopenjdk:8-jre-hotspot

WORKDIR /opt/ofbiz
COPY --from=imgbuilder /opt/ofbiz .

CMD ["/opt/ofbiz/bin/ofbiz"]
