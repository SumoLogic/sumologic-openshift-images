build-fluent-bit-v1.7.2:
	${MAKE} -C fluent-bit/v1.7.2

build-kube-state-metrics-v1.9.7:
	${MAKE} -C kube-state-metrics/v1.9.7

build-prometheus-operator-v0.43.2:
	${MAKE} -C prometheus-operator/v0.43.2

build-prometheus-v2.22.1:
	${MAKE} -C prometheus/v2.22.1

build-node-exporter-v1.0.1:
	${MAKE} -C node-exporter/v1.0.1

build-prometheus-config-reloader-v0.43.2:
	${MAKE} -C prometheus-config-reloader/v0.43.2
