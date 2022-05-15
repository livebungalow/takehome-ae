.PHONY: startup_init
startup_init:
	docker-compose up airflow-init

.PHONY: startup
startup:
	docker-compose up

.PHONY: watch
watch:
	watch -n 5 docker container ls 
