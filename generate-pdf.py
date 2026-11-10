#!/usr/bin/env python3
"""
Converts the two concatenated .swift files (produced by generate-fullcode.py)
into syntax-highlighted, landscape-oriented PDFs with line numbers.

Requires (both installed via Homebrew — no pip needed):
    brew install pygments          →  provides the  pygmentize  CLI
    brew install weasyprint        →  provides the  weasyprint  CLI
    brew install --cask font-source-code-pro  →  provides the font
"""

from __future__ import annotations

import os
import sys
import subprocess
import tempfile


# ---------------------------------------------------------------------------
# Font lookup
# ---------------------------------------------------------------------------

def find_font_path(family_fragment: str) -> tuple[str | None, str | None]:
    """
    Ask fontconfig for the regular and italic file paths of *family_fragment*.
    Returns (regular_path, italic_path); either may be None if not found.
    """
    def _fc_match(style_extra: str) -> str | None:
        result = subprocess.run(
            ["fc-match", "--format=%{file}", f"{family_fragment}:style={style_extra}"],
            capture_output=True, text=True,
        )
        path = result.stdout.strip()
        # fc-match always returns *something* — verify the name actually matches
        if path and family_fragment.lower().replace(" ", "") in path.lower().replace(" ", ""):
            return path
        return None

    return _fc_match("Regular"), _fc_match("Italic")


# ---------------------------------------------------------------------------
# CSS builder
# ---------------------------------------------------------------------------

FONT_FAMILY = "Source Code Pro"

def build_css(regular_path: str | None, italic_path: str | None) -> str:
    """Return the full CSS block, with @font-face rules if paths are known."""

    face_rules = ""
    if regular_path:
        face_rules += f"""
@font-face {{
    font-family: "{FONT_FAMILY}";
    src: url("file://{regular_path}");
    font-weight: 100 900;
    font-style: normal;
}}"""
    if italic_path:
        face_rules += f"""
@font-face {{
    font-family: "{FONT_FAMILY}";
    src: url("file://{italic_path}");
    font-weight: 100 900;
    font-style: italic;
}}"""

    return face_rules + """

/* ── Page layout ─────────────────────────────────────────────────────────── */
@page {
    size: letter landscape;
    margin: 1.5cm 1.5cm 1.5cm 1.5cm;

    /* Suppress automatic running headers and footers */
    @top-left     { content: ""; }
    @top-center   { content: ""; }
    @top-right    { content: ""; }
    @bottom-left  { content: ""; }
    @bottom-center { content: ""; }
    @bottom-right { content: ""; }
}

/* ── Base typography ──────────────────────────────────────────────────────── */
body {
    font-family: "Source Code Pro", monospace;
    font-size: 7.5pt;
    line-height: 1.35;
}

/* ── Pygments highlight wrapper ───────────────────────────────────────────── */
.highlight {
    font-family: "Source Code Pro", monospace;
    font-size: 7.5pt;
}

/* ── Line-number table (linenos=table mode) ───────────────────────────────── */
table.highlighttable {
    width: 100%;
    border-collapse: collapse;
}

td.linenos {
    width: 3.5em;
    text-align: right;
    padding-right: 0.6em;
    color: #aaa;
    border-right: 1px solid #ddd;
    vertical-align: top;
    user-select: none;
    -webkit-user-select: none;
}

td.linenos .linenodiv pre {
    margin: 0;
    padding: 0;
    background: transparent;
    color: #aaa;
}

td.code {
    padding-left: 0.6em;
    vertical-align: top;
}

pre {
    font-family: "Source Code Pro", monospace;
    font-size: 7.5pt;
}

td.code pre,
td.code .highlight pre {
    margin: 0;
    padding: 0;
    white-space: pre;        /* preserve exact indentation; no line-wrapping */
    overflow-x: visible;
}
"""


# ---------------------------------------------------------------------------
# Core conversion routine
# ---------------------------------------------------------------------------

def swift_to_pdf(swift_path: str, pdf_path: str, page_css: str) -> bool:
    """
    Run pygmentize to produce syntax-highlighted HTML, inject the page CSS,
    then run weasyprint to produce the final PDF.
    Returns True on success, False on failure.
    """

    print(f"  Highlighting  {os.path.basename(swift_path)} …")

    pg = subprocess.run(
        [
            "pygmentize",
            "-f", "html",
            "-l", "swift",
            "-O", "full=True,linenos=table,style=xcode,linenostart=1",
            swift_path,
        ],
        capture_output=True,
        text=True,
    )

    if pg.returncode != 0:
        print(f"  pygmentize error:\n{pg.stderr.strip()}")
        return False

    html = pg.stdout

    # Inject our CSS just before the closing </style> pygments already emitted
    html = html.replace("</style>", page_css + "\n</style>", 1)

    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".html", delete=False, encoding="utf-8"
    ) as tmp:
        tmp.write(html)
        tmp_path = tmp.name

    try:
        print(f"  Rendering PDF {os.path.basename(pdf_path)} …")
        wp = subprocess.run(
            ["weasyprint", tmp_path, pdf_path],
            capture_output=True,
            text=True,
        )
        if wp.returncode != 0:
            print(f"  weasyprint error:\n{wp.stderr.strip()}")
            return False
        return True
    finally:
        os.unlink(tmp_path)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def find_project_name(project_dir: str) -> str:
    for item in os.listdir(project_dir):
        if item.endswith(".xcodeproj"):
            return item[: -len(".xcodeproj")]
    return os.path.basename(project_dir)


def main():
    project_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.getcwd())
    project_name = find_project_name(project_dir)

    # Resolve font paths once — bypass weasyprint's fontconfig by using file:// URLs
    regular, italic = find_font_path(FONT_FAMILY)
    if regular:
        print(f"Font: {regular}")
    else:
        print("Warning: Source Code Pro not found via fontconfig — PDF will use fallback font.")
        print("         Run: brew install --cask font-source-code-pro")

    page_css = build_css(regular, italic)

    targets = [
        f"{project_name}-fullcode.swift",
        f"{project_name}-fullcode-no-comments.swift",
    ]

    any_ok = False
    for fname in targets:
        swift_path = os.path.join(project_dir, fname)
        if not os.path.exists(swift_path):
            print(f"Skipping {fname} — file not found. Run generate-fullcode.py first.")
            continue

        pdf_name = fname.replace(".swift", ".pdf")
        pdf_path = os.path.join(project_dir, pdf_name)

        print(f"\nGenerating {pdf_name} …")
        if swift_to_pdf(swift_path, pdf_path, page_css):
            size_kb = os.path.getsize(pdf_path) // 1024
            print(f"  Saved  {pdf_name}  ({size_kb} KB)")
            any_ok = True
        else:
            print(f"  Failed to generate {pdf_name}")

    if any_ok:
        print("\nPDF generation complete.")
    else:
        print("\nNo PDFs were generated.")
        sys.exit(1)


if __name__ == "__main__":
    main()
