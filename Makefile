build-fluent-bit-v1.6.10:
	${MAKE} -C fluent-bit/v1.6.10

build-kube-state-metrics-v1.9.7:
	${MAKE} -C kube-state-metrics/v1.9.7

build-kube-state-metrics-v1.9.8:
	${MAKE} -C kube-state-metrics/v1.9.8

build-prometheus-operator-v0.43.2:
	${MAKE} -C prometheus-operator/v0.43.2

build-prometheus-operator-v0.44.0:
	${MAKE} -C prometheus-operator/v0.44.0

build-prometheus-v2.22.1:
	${MAKE} -C prometheus/v2.22.1

build-node-exporter-v1.0.1:
	${MAKE} -C node-exporter/v1.0.1

build-node-exporter-v1.3.1:
	${MAKE} -C node-exporter/v1.3.1

build-prometheus-config-reloader-v0.43.2:
	${MAKE} -C prometheus-config-reloader/v0.43.2

build-prometheus-config-reloader-v0.44.0:
	${MAKE} -C prometheus-config-reloader/v0.44.0

build-thanos-v0.10.0:
	${MAKE} -C thanos/v0.10.0

build-thanos-v0.25.2:
	${MAKE} -C thanos/v0.25.2

build-metrics-server-0.4.2-debian-10-r58:
	${MAKE} -C metrics-server/0.4.2-debian-10-r58

build-metrics-server-0.6.1-debian-10-r67:
	${MAKE} -C metrics-server/0.6.1-debian-10-r67

build-sumologic-kubernetes-setup-v3.0.0:
	${MAKE} -C sumologic-kubernetes-setup/v3.0.0

build-sumologic-kubernetes-setup-v3.3.0:
	${MAKE} -C sumologic-kubernetes-setup/v3.3.0

build-sumologic-kubernetes-setup-v3.4.0:
	${MAKE} -C sumologic-kubernetes-setup/v3.4.0

build-telegraf-operator-v1.1.1:
	${MAKE} -C telegraf-operator/v1.1.1

build-telegraf-operator-v1.3.5:
	${MAKE} -C telegraf-operator/v1.3.5

.PHONY: build-sumo-ubi-minimal-8.4
build-sumo-ubi-minimal-8.4:
	${MAKE} -C sumo-ubi-minimal/8.4 build

.PHONY: push-sumo-ubi-minimal-8.4
push-sumo-ubi-minimal-8.4:
	${MAKE} -C sumo-ubi-minimal/8.4 push

build-kube-rbac-proxy-v0.5.0:
	${MAKE} -C kube-rbac-proxy/v0.5.0

build-kube-rbac-proxy-v0.8.0:
	${MAKE} -C kube-rbac-proxy/v0.8.0

build-telegraf-1.14.4:
	${MAKE} -C telegraf/1.14.4

build-telegraf-1.21.2:
	${MAKE} -C telegraf/1.21.2

build-opentelemetry-collector-0.22.0-sumo:
	${MAKE} -C opentelemetry-collector/0.22.0-sumo

build-sumologic-otel-collector-0.54.0-sumo-0:
	${MAKE} -C sumologic-otel-collector/0.54.0-sumo-0

build-sumologic-otel-collector-0.56.0-sumo-0:
	${MAKE} -C sumologic-otel-collector/0.56.0-sumo-0

build-sumologic-otel-collector-0.57.2-sumo-1:
	${MAKE} -C sumologic-otel-collector/0.57.2-sumo-1

build-kubernetes-fluentd-1.12.2-sumo-0:
	${MAKE} -C kubernetes-fluentd/1.12.2-sumo-0

build-kubernetes-fluentd-1.14.6-sumo-5:
	${MAKE} -C kubernetes-fluentd/1.14.6-sumo-5

build-opentelemetry-operator-0.51.0:
	${MAKE} -C opentelemetry-operator/0.51.0

build-opentelemetry-operator-0.63.1:
	${MAKE} -C opentelemetry-operator/0.63.1

build-opentelemetry-collector-contib-0.64.1:
	${MAKE} -C opentelemetry-collector-contrib/0.64.1
