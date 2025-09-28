# Penpot MCP helper targets

UV?=uv
PORT?=5000
MODE?=stdio
PYTEST_ARGS?=

.PHONY: help install sync lint lint-fix format test coverage pre-commit pre-commit-install mcp-server mcp-server-sse mcp-inspector mcp-dev clean

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

install sync: ## Install project dependencies (including dev extras)
	$(UV) sync --extra dev

lint: ## Run lint checks
	$(UV) run python lint.py

lint-fix format: ## Auto-fix lint issues where possible
	$(UV) run python lint.py --autofix

pre-commit-install: ## Install git hooks via pre-commit
	$(UV) run pre-commit install

pre-commit: ## Run pre-commit checks across the repo
	$(UV) run pre-commit run --all-files

test: ## Run the pytest suite
	$(UV) run pytest $(PYTEST_ARGS)

coverage: ## Run pytest with coverage enabled
	$(UV) run pytest --cov=penpot_mcp tests

mcp-server: ## Start the MCP server in stdio (default) or specified MODE
	$(UV) run penpot-mcp --mode $(MODE) --port $(PORT)

mcp-server-sse: ## Start the MCP server in SSE mode
	$(UV) run penpot-mcp --mode sse --port $(PORT)

mcp-inspector: ## Launch the MCP inspector (requires server running in SSE mode)
	npx @modelcontextprotocol/inspector

mcp-dev: ## Run MCP server (SSE) and inspector together
	$(UV) run penpot-mcp --mode sse --port $(PORT) & \
	INSPECTOR_PID=$$!; \
	npx @modelcontextprotocol/inspector; \
	wait $$INSPECTOR_PID

clean: ## Remove caches and build artefacts
	rm -rf .pytest_cache .coverage .coverage.* htmlcov
