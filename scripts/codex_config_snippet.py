#!/usr/bin/env python3
"""Emit a Codex config snippet for the local Penpot MCP project.

Usage:
    python scripts/codex_config_snippet.py [--name penpot] [--mode stdio]

The script prints a `config.toml` section that points the Codex CLI at the
current repository via `uv run --project ... penpot-mcp`.
"""

from __future__ import annotations

import argparse
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate a Codex MCP config snippet for this repository.",
    )
    parser.add_argument(
        "--name",
        default="penpot",
        help="Name of the MCP server entry (default: %(default)s)",
    )
    parser.add_argument(
        "--mode",
        choices=["stdio", "sse"],
        default="stdio",
        help="Default MCP mode to pass to penpot-mcp (default: %(default)s)",
    )
    parser.add_argument(
        "--api-url",
        default="https://design.penpot.app/api",
        help="Default value for PENPOT_API_URL in the snippet (default: %(default)s)",
    )
    parser.add_argument(
        "--api-key",
        default="your_penpot_access_token",
        help="Placeholder or literal value for PENPOT_API_KEY",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    project_root = Path(__file__).resolve().parent.parent

    snippet = f'''[mcp_servers.{args.name}]
command = "uv"
args = [
  "run",
  "--project",
  "{project_root}",
  "penpot-mcp",
  "--mode",
  "{args.mode}"
]
transport = "stdio"
env = {{
  PENPOT_API_URL = "{args.api_url}"
  PENPOT_API_KEY = "{args.api_key}"
}}
'''

    print(snippet, end="")


if __name__ == "__main__":
    main()
