export JAVA_HOME=$(java -XshowSettings:properties 2>&1|grep java.home|cut -c17-)
