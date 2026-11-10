#!/bin/bash
#
# generate-fullcode.sh
#
# 1. Concatenates all .swift files in this Xcode project into two files:
#       PROJECTNAME-fullcode.swift
#       PROJECTNAME-fullcode-no-comments.swift
#
# 2. Converts both files to syntax-highlighted, landscape PDFs with line numbers:
#       PROJECTNAME-fullcode.pdf
#       PROJECTNAME-fullcode-no-comments.pdf
#
# Requirements assumed to be present: macOS, Homebrew.
# All other dependencies are installed automatically if missing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Python 3 ───────────────────────────────────────────────────────────────
if ! command -v python3 &>/dev/null; then
    echo "==> Python 3 not found. Installing via Homebrew…"
    brew install python3
fi

# ── 2. Concatenate .swift files ───────────────────────────────────────────────
echo "==> Generating concatenated Swift files…"
python3 "$SCRIPT_DIR/generate-fullcode.py" "$SCRIPT_DIR"

# ── 3. pygments — provides the pygmentize CLI for syntax-highlighted HTML ─────
if ! command -v pygmentize &>/dev/null; then
    echo "==> Installing pygments via Homebrew…"
    brew install pygments
fi

# ── 4. weasyprint — provides the weasyprint CLI for HTML → PDF conversion ─────
if ! command -v weasyprint &>/dev/null; then
    echo "==> Installing weasyprint via Homebrew…"
    brew install weasyprint
fi

# ── 5. Source Code Pro font (used by weasyprint via fontconfig) ───────────────
if ! brew list --cask font-source-code-pro &>/dev/null; then
    echo "==> Installing Source Code Pro font via Homebrew…"
    brew install --cask font-source-code-pro
fi

# ── 6. Generate syntax-highlighted PDFs ──────────────────────────────────────
echo ""
echo "==> Generating syntax-highlighted PDFs…"
python3 "$SCRIPT_DIR/generate-pdf.py" "$SCRIPT_DIR"
