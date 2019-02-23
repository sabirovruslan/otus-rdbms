include .env
export

.PHONY: client
client:
	docker-compose exec ${CONTAINER_NAME} mysql -u${DB_USER} -p${DB_PASSWORD}

.PHONY: bash
bash:
	docker-compose exec ${CONTAINER_NAME} bash