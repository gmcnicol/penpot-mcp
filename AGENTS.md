# Repository Guidelines

## Project Structure & Module Organization
Penpot MCP code sits in `penpot_mcp/`: FastMCP server endpoints in `server/mcp_server.py`, the CLI client in `server/client.py`, and Penpot integrations in `api/penpot_api.py` with Transit helpers plus a 10-minute cache. Shared helpers live in `utils/`, CLI tooling in `tools/cli/`, resources in `resources/`, and mirrored tests with fixtures under `tests/`. Root scripts (`Makefile`, `lint.py`, `fix-lint-deps.sh`) support local workflows.

## Build, Test, and Development Commands
Install via `uv sync --extra dev` (or `pip install -e .[dev]`). Start the server with `uv run penpot-mcp --mode stdio` or `make mcp-server` / `make mcp-server-sse`, and pair SSE runs with `make mcp-inspector`. Lint through `uv run python lint.py` (add `--autofix`) and test using `uv run pytest` or `uv run pytest --cov=penpot_mcp tests/`. CLI helpers: `penpot-tree path/to/file.json` and `penpot-validate path/to/file.json`.

## Coding Style & Naming Conventions
Write Python 3.10+ code with four-space indents and docstrings for public members. Keep lines ≤88 characters per `.flake8`. Sort imports using `isort` (Black profile) before commits. CLI names stay snake_case and reuse `penpot-` prefixes. Run `pre-commit run --all-files` so `flake8` and `pyupgrade` keep formatting consistent.

## Architecture & Agent Workflows
The FastMCP server can expose resources as tools via `RESOURCES_AS_TOOLS`. `PenpotAPI` now authenticates with Penpot access tokens (Authorization header) and caches profile IDs for exports while still handling Transit markers such as `~u`. Typical agent flow: `list_projects` → `get_project_files` / `get_file` → `search_object` → `get_object_tree` + `penpot_tree_schema` → `export_object`. Reuse the 10-minute cache when extending features to limit API traffic.

## Testing Guidelines
Tests run on `pytest` with files named `test_*.py`. Extend fixtures in `tests/conftest.py` and cover both stdio and SSE modes for new behaviour. Add checks for Transit parsing, cache expiry, and API error handling. Use `pytest --maxfail=1 --strict-config --strict-markers` locally, and keep `test_credentials.py` predictable.

## Commit & Pull Request Guidelines
Commits follow Conventional Commit prefixes (`ci:`, `chore:`, `fix:`, `feat:`) with subjects under 72 characters and issue links when relevant. Pull requests should summarise intent, list validation commands, and attach screenshots or traces for UX changes. Update docs (`README.md`, guides) whenever interfaces shift and never commit secrets.

## Environment & Configuration Notes
Base your `.env` on `env.example`, setting `PENPOT_API_URL` and `PENPOT_API_KEY` (create tokens under **Account Settings → Access Tokens**, even for social/OAuth logins). Optional toggles: `ENABLE_HTTP_SERVER=true`, `RESOURCES_AS_TOOLS=false`, `DEBUG=true`, and `PORT=5000`. If Cloudflare blocks calls, log in via browser before retrying and note auth or port quirks in your PR.
