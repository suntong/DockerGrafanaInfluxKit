FROM grafana/grafana
#RUN apt-get update && apt-get install -y curl gettext-base && rm -rf /var/lib/apt/lists/*
WORKDIR /etc/grafana
COPY datasources ./datasources

WORKDIR /app
COPY entrypoint.sh ./
USER root
RUN chmod a+x entrypoint.sh

USER grafana
ENTRYPOINT ["/app/entrypoint.sh"]
