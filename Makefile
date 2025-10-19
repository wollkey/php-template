# Include local Makefiles with .mk ext
-include *.mk

.DEFAULT_GOAL := help
SHELL := /bin/bash

# Docker compose command setup
DC := docker compose

# PHP execution modes
PHP := $(DC) exec -e XDEBUG_MODE=off php
PHP_NO_TTY := $(DC) exec -T -e XDEBUG_MODE=off php

# Auto-detect CI environment and use non-TTY mode
ifdef CI
    PHP := $(PHP_NO_TTY)
endif

# Debug mode - enable Xdebug when 'debug' is in command
# Usage: make debug test
ifneq (,$(findstring debug,$(MAKECMDGOALS)))
    PHP := $(subst -e XDEBUG_MODE=off ,,$(PHP))
    PHP_NO_TTY := $(subst -e XDEBUG_MODE=off ,,$(PHP_NO_TTY))
    $(eval debug:;@:)
endif

# Colors for better readability
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
RESET  := \033[0m

##
## Project Setup & Control
## -----------------------

help: ## Show this help message
	@echo -e "$(BLUE)Available commands:$(RESET)"
	@echo -e "$(YELLOW)Tip: Use 'make debug <command>' to enable Xdebug (e.g., make debug test)$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'
.PHONY: help

fresh: down cache-clear setup up install ## Fresh start (stop, clear cache, rebuild)
	@echo -e "$(GREEN)✓ Fresh environment ready$(RESET)"
.PHONY: fresh

setup: ## Initial project setup
	@[ -f .env.local ] || cp .env.local.example .env.local 2>/dev/null || touch .env.local
	@mkdir -p var/cache var/log
	@echo -e "$(GREEN)✓ Project setup complete$(RESET)"
.PHONY: setup

install: ## Install all dependencies
	$(PHP) composer install
	@echo -e "$(GREEN)✓ Dependencies installed$(RESET)"
.PHONY: install

update: ## Update dependencies
	$(PHP) composer update
	@echo -e "$(GREEN)✓ Dependencies updated$(RESET)"
.PHONY: update

##
## Docker Management
## -----------------

build: ## Build Docker images
	$(DC) build --pull
.PHONY: build

up: ## Start all containers
	$(DC) up -d
	@echo -e "$(GREEN)✓ Containers started$(RESET)"
.PHONY: up

down: ## Stop all containers
	$(DC) down
	@echo -e "$(GREEN)✓ Containers stopped$(RESET)"
.PHONY: down

restart: down up ## Restart all containers
.PHONY: restart

logs: ## Show container logs (usage: make logs [service=php])
	$(DC) logs -f $(service)
.PHONY: logs

sh: ## Open shell in PHP container
	$(PHP) sh
.PHONY: sh

ps: ## Show running containers
	$(DC) ps
.PHONY: ps

##
## Code Quality
## ------------

test: ## Run all tests
	$(PHP) vendor/bin/phpunit
.PHONY: test

test-coverage: ## Run tests with coverage report
	$(PHP) vendor/bin/phpunit --coverage-html var/coverage
.PHONY: test-coverage

psalm: ## Run Psalm static analysis
	$(PHP) vendor/bin/psalm --no-cache
.PHONY: psalm

psalm-baseline: ## Update Psalm baseline
	$(PHP) vendor/bin/psalm --set-baseline=psalm-baseline.xml
.PHONY: psalm-baseline

cs-check: ## Check code style with PHP CS Fixer
	$(PHP) vendor/bin/php-cs-fixer fix --dry-run --diff --verbose
.PHONY: cs-check

cs-fix: ## Fix code style with PHP CS Fixer
	$(PHP) vendor/bin/php-cs-fixer fix --verbose
.PHONY: cs-fix

rector: ## Run Rector refactoring
	$(PHP) vendor/bin/rector process
.PHONY: rector

rector-check: ## Check Rector rules (dry run)
	$(PHP) vendor/bin/rector process --dry-run
.PHONY: rector-check

composer-validate: ## Validate composer.json
	$(PHP) composer validate --strict
.PHONY: composer-validate

composer-audit: ## Check for security vulnerabilities
	$(PHP) composer audit
.PHONY: composer-audit

composer-outdated: ## Show outdated packages
	$(PHP) composer outdated --direct
.PHONY: composer-outdated

composer-check: composer-validate composer-audit ## Run all composer checks
	@echo -e "$(GREEN)✓ Composer checks passed$(RESET)"
.PHONY: composer-check

code-check: cs-check psalm rector-check test ## Run all code quality checks
	@echo -e "$(GREEN)✓ Code checks passed$(RESET)"
.PHONY: code-check

check: code-check composer-check ## Run all checks
	@echo -e "$(GREEN)✓ All checks passed$(RESET)"
.PHONY: check

fix: cs-fix rector ## Apply all automatic fixes
.PHONY: fix

##
## Database
## --------

db-create: ## Create database
	$(PHP) bin/console doctrine:database:create --if-not-exists
.PHONY: db-create

db-drop: ## Drop database
	$(PHP) bin/console doctrine:database:drop --if-exists --force
.PHONY: db-drop

db-migrate: ## Run migrations
	$(PHP) bin/console doctrine:migrations:migrate --no-interaction
.PHONY: db-migrate

db-migration: ## Generate new migration
	$(PHP) bin/console doctrine:migrations:diff
.PHONY: db-migration

db-fixtures: ## Load fixtures
	$(PHP) bin/console doctrine:fixtures:load --no-interaction
.PHONY: db-fixtures

db-reset: db-drop db-create db-migrate db-fixtures ## Reset database with fixtures
	@echo -e "$(GREEN)✓ Database reset complete$(RESET)"
.PHONY: db-reset

##
## Cache & Cleanup
## ---------------

cache-clear: ## Clean var directory (cache, logs)
	rm -rf var/cache/* var/log/*
	@echo -e "$(GREEN)✓ Cache cleared$(RESET)"
.PHONY: cache-clear

##
## Utilities
## ---------

info: ## Show project information
	@echo -e "$(BLUE)Project Information$(RESET)"
	@echo "Docker containers:"
	@$(DC) ps
	@echo ""
	@echo "PHP version:"
	@$(PHP) php -v | head -n 1
	@echo ""
	@echo "Composer version:"
	@$(PHP) composer --version
.PHONY: info

php-version: ## Show PHP version
	$(PHP) php -v
.PHONY: php-version
