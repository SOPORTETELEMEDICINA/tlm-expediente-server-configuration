# Dockerfile de nio-expediente
FROM openjdk:8-jdk-alpine
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
#COPY ./src/main/resources/static/dev.niomedic.com.key /opt/secrets/
#COPY ./src/main/resources/static/telemedicina_lat.key /opt/secrets/
COPY ./src/main/resources/static/stre_red.key /opt/secrets/
#COPY ./src/972d96bf3b3cb7e8.crt $JAVA_HOME/jre/lib/security

# SECCION PARA PRUEBAS INICIA
#COPY ./src/jonima2019.crt $JAVA_HOME/jre/lib/security
#VOLUME /tmp
#VOLUME /logs
#VOLUME /var/www/html/niomedic/documentos
#VOLUME /var/www/html/niomedic/imagenesLaboratorio
#ADD target/nio-expediente-1.0.9-SNAPSHOT.jar app.jar
#ENV JAVA_OPTS="-Xmx1024m -Duser.timezone=America/Mexico_City"
#ENV JRE_KEYSTORE=$JAVA_HOME/jre/lib/security/cacerts
#ENV CER_DIR=$JAVA_HOME/jre/lib/security/jonima2019.crt
#RUN keytool -import -alias jonimacert -storepass changeit -noprompt -keystore $JRE_KEYSTORE -trustcacerts -file $CER_DIR
# SECCION PARA PRUEBAS TERMINA

# SECCION PARA PRODUCCION INICIA
#COPY ./src/STAR_telemedicina_lat.crt $JAVA_HOME/jre/lib/security
COPY ./src/stre_red.crt $JAVA_HOME/jre/lib/security
VOLUME /tmp
VOLUME /logs
VOLUME /var/www/html/niomedic/documentos
VOLUME /var/www/html/niomedic/imagenesLaboratorio
ADD target/nio-expediente-1.0.9-SNAPSHOT.jar app.jar
ENV JAVA_OPTS="-Duser.timezone=America/Mexico_City"
ENV JRE_KEYSTORE=$JAVA_HOME/jre/lib/security/cacerts
##ENV CER_DIR=$JAVA_HOME/jre/lib/security/STAR_telemedicina_lat.crt
ENV CER_DIR=$JAVA_HOME/jre/lib/security/stre_red.crt
#RUN keytool -import -alias ece.telemedicina.lat -storepass changeit -noprompt -keystore $JRE_KEYSTORE -trustcacerts -file $CER_DIR
RUN keytool -import -alias stre.red -storepass changeit -noprompt -keystore $JRE_KEYSTORE -trustcacerts -file $CER_DIR
# SECCION PARA PRODUCCION TERMINA

RUN apk --update add fontconfig ttf-dejavu
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar