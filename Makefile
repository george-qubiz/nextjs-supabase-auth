DOCKER_NETWORK := next_supa

install/pnpm:
	pnpm install

install/supabase:
	npx supabase start --network-id ${DOCKER_NETWORK}
	npx supabase status

init: install/pnpm install/supabase
	echo "Installed successfully"

network: ## Create a public network.
	docker network create ${DOCKER_NETWORK}
.PHONY: network

start:
	echo "Starting"

clean/network:
	docker network rm ${DOCKER_NETWORK}

clean/supabase:
	pnpm supabase:stop

build: network init start
	docker-compose up -d --build

next/restart:
	docker-compose up -d

next/build:
	docker-compose up -d --build

next/stop:
	docker-compose down

up: network init start
	docker-compose up -d

down: clean/supabase
	docker-compose down
	make clean/network
