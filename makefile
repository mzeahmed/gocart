ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.DEFAULT_GOAL := help

COMPOSE := docker compose -f docker-compose.yml

APP_CONTAINER := gocart

DOMAINS := gocart.local mail.gocart.local db.gocart.local

GREEN  := \033[0;32m
YELLOW := \033[1;33m
BLUE   := \033[0;34m
RED    := \033[0;31m
RESET  := \033[0m

CERT_FILE := certs/gocart.local.pem
CERT_KEY  := certs/gocart.local-key.pem

.PHONY: help run build \
        fmt vet test check \
        tidy update \
        clean doctor \
        hosts certs up down restart logs ps bash \
        migrate-up migrate-down sqlc

help: ## Show available commands
	@echo ""
	@echo "$(BLUE)GoCart Development Commands$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ {printf "  \033[32m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

# ==============================================================================
# Quality
# ==============================================================================

fmt: ## Format the source code
	go fmt ./...

vet: ## Run go vet
	go vet ./...

test: ## Run unit tests
	go test ./...

check: fmt vet test ## Run all quality checks

# ==============================================================================
# Dependencies
# ==============================================================================

tidy: ## Clean up go.mod / go.sum
	go mod tidy

update: ## Update dependencies
	go get -u ./...
	go mod tidy
