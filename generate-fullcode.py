#!/usr/bin/env python3
"""
Generates two concatenated Swift source files for an Xcode project:

  PROJECTNAME-fullcode.swift
      All .swift files in the project concatenated in sorted order,
      separated by a small file-path header.

  PROJECTNAME-fullcode-no-comments.swift
      The same concatenation with every comment replaced by blank space,
      keeping the total line count identical so the two files line up
      perfectly when viewed side-by-side.

Usage:
  python3 generate-fullcode.py              # run from project root
  python3 generate-fullcode.py /path/to/project
"""

import os
import sys


# ---------------------------------------------------------------------------
# Project / file discovery
# ---------------------------------------------------------------------------

def find_project_name(project_dir: str) -> str:
    """Return the stem of the first .xcodeproj bundle found, or the dir name."""
    for item in os.listdir(project_dir):
        if item.endswith(".xcodeproj"):
            return item[: -len(".xcodeproj")]
    return os.path.basename(project_dir)


def find_swift_files(project_dir: str, exclude_names: set) -> list:
    """
    Walk *project_dir* and return all .swift paths in sorted order,
    skipping hidden dirs, DerivedData, build artefacts, and any filename
    in *exclude_names* (so re-running never includes a previous output file).
    """
    results = []
    skip_dirs = {".git", ".build", "DerivedData", "build", "Pods"}

    for root, dirs, files in os.walk(project_dir):
        dirs[:] = sorted(d for d in dirs if d not in skip_dirs and not d.startswith("."))
        for fname in sorted(files):
            if fname.endswith(".swift") and fname not in exclude_names:
                results.append(os.path.join(root, fname))

    return results


# ---------------------------------------------------------------------------
# Comment stripping  (line-count-preserving)
# ---------------------------------------------------------------------------

def strip_comments(source: str) -> str:
    """
    Return *source* with all Swift comments replaced by whitespace/blank lines
    so that every line in the output corresponds to the same-numbered line in
    the input.

    Rules:
      • A line that is *entirely* a // comment → blank line
      • A // comment at the end of a code line → trailing comment removed,
        code kept (line is NOT blanked)
      • /* ... */ block comments → each line of the block is blanked;
        any code that appears before /* or after */ on the same line is kept
      • // and /* inside string literals are left untouched
      • Multi-line strings (triple-quoted) are handled at a line level
        (opening/closing triple-quotes on the same line is handled correctly;
         genuine multi-line strings are rare in the targeted code base)
    """

    lines = source.split("\n")
    out = []
    in_block = False          # currently inside /* … */ ?
    in_multiline_str = False  # currently inside """ … """ ?

    for line in lines:
        processed, in_block, in_multiline_str = _process_line(
            line, in_block, in_multiline_str
        )
        out.append(processed)

    return "\n".join(out)


def _process_line(line: str, in_block: bool, in_multiline_str: bool):
    """
    Process one line and return (result_line, in_block, in_multiline_str).

    *result_line* has the same length-in-characters as needed to preserve
    meaning but comments are removed.  Importantly the *number of lines*
    never changes — we never insert or delete newlines here.
    """
    buf = []
    i = 0
    n = len(line)

    while i < n:
        c = line[i]

        # ----------------------------------------------------------------
        # 1. Inside a /* … */ block comment
        # ----------------------------------------------------------------
        if in_block:
            if line[i : i + 2] == "*/":
                in_block = False
                i += 2
                # Any code that follows on this line continues normally
            else:
                i += 1
            # Either way, nothing is appended → this part of the line is blank

        # ----------------------------------------------------------------
        # 2. Inside a multi-line """ string
        # ----------------------------------------------------------------
        elif in_multiline_str:
            if line[i : i + 3] == '"""':
                buf.append('"""')
                i += 3
                in_multiline_str = False
            else:
                buf.append(c)
                i += 1

        # ----------------------------------------------------------------
        # 3. Normal code
        # ----------------------------------------------------------------
        else:
            # Triple-quoted string open
            if line[i : i + 3] == '"""':
                buf.append('"""')
                i += 3
                in_multiline_str = True

            # Regular string literal
            elif c == '"':
                buf.append(c)
                i += 1
                while i < n:
                    ch = line[i]
                    if ch == "\\" and i + 1 < n:
                        buf.append(line[i : i + 2])
                        i += 2
                    elif ch == '"':
                        buf.append(ch)
                        i += 1
                        break
                    else:
                        buf.append(ch)
                        i += 1

            # Single-line comment  //
            elif line[i : i + 2] == "//":
                # Discard the rest of this line — stop processing
                break

            # Block comment open  /*
            elif line[i : i + 2] == "/*":
                in_block = True
                i += 2
                # Code already emitted into buf is kept; comment is dropped

            else:
                buf.append(c)
                i += 1

    result = "".join(buf).rstrip()
    return result, in_block, in_multiline_str


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    project_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.getcwd())

    project_name = find_project_name(project_dir)
    print(f"Project : {project_name}")
    print(f"Root    : {project_dir}")

    fullcode_name    = f"{project_name}-fullcode.swift"
    nocomments_name  = f"{project_name}-fullcode-no-comments.swift"

    swift_files = find_swift_files(project_dir, exclude_names={fullcode_name, nocomments_name})
    print(f"Files   : {len(swift_files)} .swift files found")

    # ------------------------------------------------------------------
    # Build the concatenated text with file-path separators
    # ------------------------------------------------------------------
    # Each separator is exactly 3 lines:
    #   // ============================================================
    #   // File: path/relative/to/project/root
    #   // ============================================================
    # Because the separator itself consists of // comments, the
    # no-comments version will automatically blank those 3 lines when
    # strip_comments() runs — line counts stay in sync with zero effort.

    parts = []
    for path in swift_files:
        rel = os.path.relpath(path, project_dir)
        sep = f"// {'=' * 60}\n// File: {rel}\n// {'=' * 60}\n"
        with open(path, encoding="utf-8") as fh:
            content = fh.read()
        # Guarantee the file body ends with exactly one newline
        content = content.rstrip("\n") + "\n"
        parts.append(sep + content)

    full_text = "\n".join(parts)          # blank line between files
    no_comments_text = strip_comments(full_text)

    # ------------------------------------------------------------------
    # Write output files
    # ------------------------------------------------------------------
    fullcode_path   = os.path.join(project_dir, fullcode_name)
    nocomments_path = os.path.join(project_dir, nocomments_name)

    with open(fullcode_path,   "w", encoding="utf-8") as fh:
        fh.write(full_text)

    with open(nocomments_path, "w", encoding="utf-8") as fh:
        fh.write(no_comments_text)

    # ------------------------------------------------------------------
    # Sanity check: line counts must match
    # ------------------------------------------------------------------
    full_lines = full_text.count("\n")
    nc_lines   = no_comments_text.count("\n")

    print(f"\nOutput  : {fullcode_name}  ({full_lines} lines)")
    print(f"Output  : {nocomments_name}  ({nc_lines} lines)")

    if full_lines == nc_lines:
        print("\nLine counts match — files are in sync.")
    else:
        print(f"\nWARNING: line count mismatch ({full_lines} vs {nc_lines}). "
              "Please file a bug with the offending Swift file.")


if __name__ == "__main__":
    main()
