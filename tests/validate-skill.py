#!/usr/bin/env python3
import pathlib
import re
import sys


def fail(message: str) -> None:
    print(f"validate-skill: {message}", file=sys.stderr)
    raise SystemExit(1)


root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "skills/fair-contribution-commits")
skill_md = root / "SKILL.md"
openai_yaml = root / "agents" / "openai.yaml"

if not skill_md.is_file():
    fail(f"missing {skill_md}")

text = skill_md.read_text(encoding="utf-8")
if not text.startswith("---\n"):
    fail("SKILL.md must start with YAML frontmatter")

parts = text.split("---\n", 2)
if len(parts) != 3:
    fail("SKILL.md frontmatter must be closed")

frontmatter = parts[1].strip().splitlines()
body = parts[2]
meta = {}

for line in frontmatter:
    if ":" not in line:
        fail(f"invalid frontmatter line: {line}")
    key, value = line.split(":", 1)
    key = key.strip()
    value = value.strip()
    if key not in {"name", "description"}:
        fail(f"unexpected frontmatter key: {key}")
    meta[key] = value

name = meta.get("name", "")
description = meta.get("description", "")

if not re.fullmatch(r"[a-z0-9-]{1,63}", name):
    fail(f"invalid skill name: {name}")

if name != root.name:
    fail(f"skill name {name} does not match folder {root.name}")

if len(description) < 80:
    fail("description is too short to trigger reliably")

if len(body.splitlines()) > 500:
    fail("SKILL.md body exceeds 500 lines")

if "Co-authored-by: Codex <267193182+codex@users.noreply.github.com>" not in text:
    fail("missing required Codex trailer")

if not openai_yaml.is_file():
    fail(f"missing {openai_yaml}")

openai_text = openai_yaml.read_text(encoding="utf-8")
if "$fair-contribution-commits" not in openai_text:
    fail("agents/openai.yaml default prompt must mention $fair-contribution-commits")

print("OK: skill validation passed")
