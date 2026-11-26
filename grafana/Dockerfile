FROM grafana/grafana:11.2.2

ENV GF_SECURITY_ADMIN_USER=admin \
    GF_SECURITY_ADMIN_PASSWORD=admin \
    GF_USERS_ALLOW_SIGN_UP=false

COPY provisioning/datasources/prometheus.yml /etc/grafana/provisioning/datasources/prometheus.yml

EXPOSE 3000
