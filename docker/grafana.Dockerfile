FROM grafana/grafana:10.4.3
USER root
COPY grafana/provisioning/datasources/datasource.yml /etc/grafana/provisioning/datasources/datasource.yml
COPY grafana/provisioning/dashboards/dashboard.yml /etc/grafana/provisioning/dashboards/dashboard.yml
COPY grafana/dashboards/evolution-dashboard.json /etc/grafana/dashboards/evolution-dashboard.json
RUN chown -R grafana:root /etc/grafana/provisioning /etc/grafana/dashboards
USER grafana
