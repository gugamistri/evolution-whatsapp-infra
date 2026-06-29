#!/bin/sh
set -eu

VHOST="${RABBITMQ_DEFAULT_VHOST:-evolution}"

rabbitmqctl add_user crm "${RABBITMQ_CRM_PASSWORD}" 2>/dev/null || \
  rabbitmqctl change_password crm "${RABBITMQ_CRM_PASSWORD}"

rabbitmqctl set_permissions -p "${VHOST}" crm "" "" ".*"
