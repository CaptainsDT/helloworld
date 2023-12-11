FROM 192.168.203.40:80/library/debian:stable-slim
MAINTAINER DT
RUN ln -svf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir -p /app/conf
ADD helloworld /app
ADD conf/app.conf /app/conf/
WORKDIR /app
RUN chmod a+x /app/helloworld
EXPOSE 9091
CMD ["/bin/bash", "-c", "./helloworld"]
