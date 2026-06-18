# Askalot QML Module Build System

# UV is the primary package manager for all Python operations
UV := uv
PYTHON := uv run python

.DEFAULT_GOAL := help

.PHONY: help sync lock build test test-unit test-integration test-coverage clean install lint format info benchmark benchmark-test

help: ## Show this help message
	@echo "🔧 Askalot QML Module"
	@echo "====================="
	@echo ""
	@echo "Main Commands:"
	@echo "  sync                 Sync dependencies from uv.lock"
	@echo "  lock                 Update uv.lock with latest compatible versions"
	@echo "  build                Build distribution packages"
	@echo "  install              Install in development mode"
	@echo "  test                 Run all tests"
	@echo ""
	@echo "Other Commands:"
	@awk 'BEGIN {FS = ":.*##"}; /^[a-zA-Z_-]+:.*##/ { if ($$1 != "sync" && $$1 != "lock" && $$1 != "build" && $$1 != "install" && $$1 != "test") printf "  %-20s %s\\n", $$1, $$2 }' $(MAKEFILE_LIST)

sync: ## Sync dependencies from uv.lock (creates .venv if needed)
	@echo "🔄 Syncing dependencies for askalot_qml..."
	$(UV) sync --all-extras
	@echo "✅ Dependencies synchronized"

lock: ## Update uv.lock with latest compatible versions
	@echo "🔒 Updating uv.lock for askalot_qml..."
	$(UV) lock
	@echo "✅ Lock file updated"

build: ## Build distribution packages (sdist and wheel)
	@echo "📦 Building askalot_qml distribution packages..."
	$(UV) build
	@echo "✅ Build complete - packages in dist/"

install: ## Install package in development mode
	@echo "📥 Installing askalot_qml in development mode..."
	$(UV) pip install -e .
	@echo "✅ Package installed"

test: ## Run all tests
	@echo "🧪 Running all tests for askalot_qml..."
	$(PYTHON) -m pytest tests/ -v

test-unit: ## Run unit tests only
	@echo "🧪 Running unit tests for askalot_qml..."
	$(PYTHON) -m pytest tests/unit/ -v -m unit

test-integration: ## Run integration tests only
	@echo "🧪 Running integration tests for askalot_qml..."
	$(PYTHON) -m pytest tests/integration/ -v -m integration

test-coverage: ## Run tests with coverage report
	@echo "📊 Running tests with coverage for askalot_qml..."
	$(PYTHON) -m pytest tests/ --cov=askalot_qml --cov-report=html --cov-report=term
	@echo "📊 Coverage report generated in htmlcov/"

clean: ## Clean build artifacts and cache
	@echo "🧹 Cleaning build artifacts from askalot_qml..."
	rm -rf build dist *.egg-info
	rm -rf .pytest_cache .coverage htmlcov
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	@echo "✅ Clean complete"

lint: ## Run code linting
	@echo "🔍 Running code linting on askalot_qml..."
	$(UV) run ruff askalot_qml/ tests/
	@echo "✅ Linting completed"

format: ## Format code with black and isort
	@echo "🎨 Formatting askalot_qml code..."
	$(UV) run black askalot_qml/ tests/
	$(UV) run ruff --fix askalot_qml/ tests/
	@echo "✅ Code formatted"

benchmark: ## Run a fast end-to-end validator benchmark (smoke) and render figures
	@echo "📈 Running QML validator benchmark (smoke sweep)..."
	$(UV) run --project benchmark python -m benchmark.sweep --smoke
	$(UV) run --project benchmark python -m benchmark.plot
	@echo "✅ Results in benchmark/results/, figures in benchmark/figures/"

benchmark-test: ## Run the benchmark harness's own test suite
	@echo "🧪 Running benchmark harness tests..."
	$(UV) run --project benchmark python -m pytest benchmark/tests

info: ## Show package information
	@echo "📋 Askalot QML Module Information"
	@echo "================================="
	@echo "UV: $(UV)"
	@echo "Python: $(PYTHON)"
	@echo "Module: askalot_qml (QML processing and analysis)"
	@echo "Purpose: QML parsing, Z3 analysis, survey flow processing"
	@echo "Status: Production-ready"