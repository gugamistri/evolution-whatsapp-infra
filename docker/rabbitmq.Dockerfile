FROM rabbitmq:3.13-management-alpine
COPY rabbitmq/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY rabbitmq/init-add-crm-user.sh /docker-entrypoint-init.d/20-init-crm-user.sh
RUN chmod +x /docker-entrypoint-init.d/20-init-crm-user.sh
