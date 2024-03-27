.PHONY: help build up down logs ps test
.DEFAULT_GOAL := help

DOCKER_TAG := latest
build: ## 배포용 도커 이미지 빌드
	docker build -t pdj107/gotodo:${DOCKER_TAG} \
		--target deploy ./

up: ## docker compose 실행
	docker compose up -d
	
down: ## docker compose 종료
	docker compose down

logs: ## docker compose 로그 출력
	docker compose logs -f

ps: ## 컨테이너 상태 확인
	docker compose ps

test: ## 테스트 실행
	go test -race -shuffle=on ./...

dry-migrate: ## Try migration
	mysqldef -u todo -p todo -h 192.168.10.51 -P 33306 todo --dry-run < ./_tools/mysql/schema.sql

migrate:  ## Execute migration
	mysqldef -u todo -p todo -h 192.168.10.51 -P 33306 todo < ./_tools/mysql/schema.sql

generate: ## Generate codes
	go generate ./...

help: ## 옵션 보기
		@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m\t$$(echo $$l | cut -f 3- -d'#')\n"; done
