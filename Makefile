.DEFAULT_GOAL := help
SHELL := /bin/bash
PY := python3
CORES ?= 4
CONFIG ?= config/config.yaml

.PHONY: help install install-dev lint format typecheck test test-fast smoke pipeline dag lint-workflow docs docs-serve figures report clean clean-results checksums freeze

help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

install: ## Install the package in editable mode
	$(PY) -m pip install -e .

install-dev: ## Install the package with development extras and git hooks
	$(PY) -m pip install -e ".[dev]"
	pre-commit install

lint: ## Run ruff checks
	ruff check src tests
	ruff format --check src tests

format: ## Auto-format the codebase
	ruff format src tests
	ruff check --fix src tests

typecheck: ## Run mypy
	mypy

test: ## Run the full test suite with coverage
	pytest

test-fast: ## Run the test suite without slow or gpu tests
	pytest -m "not slow and not gpu" --no-cov

smoke: ## Run the end-to-end pipeline on committed synthetic fixtures
	$(PY) -m cdmp.cli smoke --outdir results/smoke

pipeline: ## Run the full Snakemake workflow
	snakemake --snakefile workflow/Snakefile --configfile $(CONFIG) --cores $(CORES) --use-conda --rerun-triggers mtime

dag: ## Render the workflow DAG to docs/assets/dag.svg
	snakemake --snakefile workflow/Snakefile --configfile $(CONFIG) --dag | dot -Tsvg > docs/assets/dag.svg

lint-workflow: ## Lint the Snakemake workflow
	snakemake --snakefile workflow/Snakefile --configfile $(CONFIG) --lint

checksums: ## Verify every declared input against config/checksums/manifest.sha256
	$(PY) -m cdmp.cli verify-checksums --manifest config/checksums/manifest.sha256

figures: ## Regenerate all manuscript figures from processed results
	$(PY) -m cdmp.cli figures --config $(CONFIG)

report: ## Regenerate the technical report and result tables
	$(PY) -m cdmp.cli report --config $(CONFIG)

docs: ## Build the documentation site
	mkdocs build --strict

docs-serve: ## Serve the documentation locally
	mkdocs serve

freeze: ## Record the exact environment for the provenance log
	$(PY) -m cdmp.cli env-report --output results/logs/env_report.json

clean: ## Remove build and cache artefacts
	rm -rf build dist .pytest_cache .mypy_cache .ruff_cache htmlcov .coverage coverage.xml
	find . -name '__pycache__' -type d -prune -exec rm -rf {} +

clean-results: ## Remove derived results but keep raw downloads
	rm -rf results data/interim data/processed
