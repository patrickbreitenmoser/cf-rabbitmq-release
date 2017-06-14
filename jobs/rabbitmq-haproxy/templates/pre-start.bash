#!/bin/bash -e

[ -z "$DEBUG" ] || set -x

JOB_DIR=/var/vcap/jobs/rabbitmq-haproxy
ROOT_LOG_DIR=/var/vcap/sys/log
INIT_LOG_DIR=/var/vcap/sys/log/rabbitmq-haproxy
SERVICE_METRICS_DIR=/var/vcap/sys/log/service-metrics

source /var/vcap/packages/rabbitmq-common/ensure_dir_with_permissions

KNOWN_PACKAGES="$("$(dirname "$0")/known-packages.bash")"

symlink_haproxy_syslog_configuration() {
    ln -sfv $JOB_DIR/config/haproxy_syslog.conf /etc/rsyslog.d/haproxy_syslog.conf
}

restart_rsyslog() {
    /usr/sbin/service rsyslog restart
}

main() {
    ensure_dir_with_permissions "${ROOT_LOG_DIR}"
    ensure_dir_with_permissions "${INIT_LOG_DIR}"
    ensure_dir_with_permissions "${SERVICE_METRICS_DIR}"
    ensure_dir_with_permissions "${JOB_DIR}"
    ensure_dir_with_permissions "${JOB_DIR}/packages"

    for package in ${KNOWN_PACKAGES}; do
      ensure_dir_with_permissions "${JOB_DIR}/packages/$package"
    done

    symlink_haproxy_syslog_configuration
    restart_rsyslog
}

main