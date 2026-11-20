.PHONY: help install dev-backend dev-admin seed docker-up docker-down docker-build clean

help:
	@echo "City Civic — Development Commands"
	@echo "================================="
	@echo "  make install       Install dependencies for backend and admin"
	@echo "  make dev-backend   Start Node/Express backend in dev mode"
	@echo "  make dev-admin     Start React/Vite admin dashboard in dev mode"
	@echo "  make seed          Seed MongoDB with initial demo data"
	@echo "  make docker-up     Start all services via Docker Compose"
	@echo "  make docker-down   Stop Docker Compose services"
	@echo "  make docker-build  Rebuild Docker Compose services"
	@echo "  make clean         Remove build artifacts and temporary logs"

install:
	cd backend && npm install
	cd admin && npm install

dev-backend:
	cd backend && npm run dev

dev-admin:
	cd admin && npm run dev

seed:
	cd backend && npm run seed

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-build:
	docker-compose build

clean:
	rm -rf admin/dist admin/devserver.log
