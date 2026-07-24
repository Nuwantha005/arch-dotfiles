#!/usr/bin/env python3
"""
generate_paper_covers.py

For each note in a specified Obsidian vault folder:
  1. Reads the `pdf:` frontmatter field to find the linked PDF
  2. Renders the first page as a PNG thumbnail
  3. Saves it alongside your existing attachments
  4. Writes a `cover:` property back into the note frontmatter

Usage:
    # Research papers (default folder)
    python generate_paper_covers.py --vault /path/to/vault

    # Articles (or any other folder)
    python generate_paper_covers.py --vault /path/to/vault --folder 07_REFERENCES/Articles

    # Force-regenerate all covers
    python generate_paper_covers.py --vault /path/to/vault --folder 07_REFERENCES/Articles --force

Requirements:
    pip install pymupdf pyyaml

The script is safe to re-run — it skips notes that already have a `cover:` property.
Pass --force to regenerate all covers regardless.
"""

import argparse
import re
import sys
from pathlib import Path

try:
    import fitz  # PyMuPDF
except ImportError:
    sys.exit("PyMuPDF not found. Run: pip install pymupdf")

try:
    import yaml
except ImportError:
    sys.exit("PyYAML not found. Run: pip install pyyaml")


# ── Config ────────────────────────────────────────────────────────────────────

DEFAULT_PAPERS_FOLDER = "07_REFERENCES/Research Papers"  # used when --folder not given
ATTACHMENTS_DIR       = "attachments"                    # relative to the target folder
COVER_PROPERTY        = "cover"                          # frontmatter key to write
THUMBNAIL_SIZE        = (800, 1100)                      # max width × height in px
DPI                   = 150                              # render DPI

# ── Helpers ───────────────────────────────────────────────────────────────────

FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)
WIKILINK_RE    = re.compile(r"^\[\[(.+?)(?:\|.*)?\]\]$")


def parse_frontmatter(text: str):
    """Return (dict, body_after_frontmatter) or (None, text)."""
    m = FRONTMATTER_RE.match(text)
    if not m:
        return None, text
    try:
        data = yaml.safe_load(m.group(1)) or {}
    except yaml.YAMLError:
        return None, text
    body = text[m.end():]
    return data, body


def serialise_frontmatter(data: dict, body: str) -> str:
    """Rebuild the full note with updated frontmatter."""
    fm = yaml.dump(data, allow_unicode=True, default_flow_style=False, sort_keys=False)
    return f"---\n{fm}---\n{body}"


def resolve_pdf_path(pdf_value: str, vault_root: Path) -> Path | None:
    """
    Accepts either:
      - a full wikilink  [[07_REFERENCES/Articles/attachments/foo.pdf]]
      - a short wikilink [[foo.pdf]]  (Obsidian shortest-path format)
      - a plain path     07_REFERENCES/Articles/attachments/foo.pdf
    Returns an absolute Path or None.
    """
    if not pdf_value:
        return None
    pdf_value = str(pdf_value).strip()
    m = WIKILINK_RE.match(pdf_value)
    if m:
        pdf_value = m.group(1)

    # Try as a full/relative path first
    candidate = vault_root / pdf_value
    if candidate.exists():
        return candidate

    # Fallback: search the whole vault for a file with this name
    filename = Path(pdf_value).name
    matches = list(vault_root.rglob(filename))
    if matches:
        if len(matches) > 1:
            print(f"  ! Multiple files named '{filename}' found, using first: {matches[0]}")
        return matches[0]

    return None


def extract_cover(pdf_path: Path, out_path: Path) -> bool:
    """Render first page of PDF to out_path. Returns True on success."""
    try:
        doc = fitz.open(str(pdf_path))
        page = doc[0]
        mat = fitz.Matrix(DPI / 72, DPI / 72)
        pix = page.get_pixmap(matrix=mat, alpha=False)
        # Downscale if larger than THUMBNAIL_SIZE
        if pix.width > THUMBNAIL_SIZE[0] or pix.height > THUMBNAIL_SIZE[1]:
            scale = min(THUMBNAIL_SIZE[0] / pix.width, THUMBNAIL_SIZE[1] / pix.height)
            mat2 = fitz.Matrix(scale, scale)
            pix = page.get_pixmap(matrix=mat2, alpha=False)
        pix.save(str(out_path))
        doc.close()
        return True
    except Exception as e:
        print(f"  ✗ Could not render PDF: {e}")
        return False


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Generate PDF cover thumbnails for Obsidian notes (papers, articles, books)."
    )
    parser.add_argument(
        "--vault",
        required=True,
        help="Absolute path to your Obsidian vault root",
    )
    parser.add_argument(
        "--folder",
        default=DEFAULT_PAPERS_FOLDER,
        help=(
            f"Vault-relative folder to scan for notes "
            f"(default: '{DEFAULT_PAPERS_FOLDER}'). "
            "Example: --folder '07_REFERENCES/Articles'"
        ),
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Regenerate covers even if already present",
    )
    args = parser.parse_args()

    vault_root = Path(args.vault).expanduser().resolve()
    notes_dir  = vault_root / args.folder
    attach_dir = notes_dir / ATTACHMENTS_DIR

    if not notes_dir.exists():
        sys.exit(f"Folder not found: {notes_dir}")

    attach_dir.mkdir(exist_ok=True)

    notes = list(notes_dir.glob("*.md"))
    print(f"Scanning : {notes_dir}")
    print(f"Thumbnails → {attach_dir}")
    print(f"Found {len(notes)} markdown files\n")

    updated = skipped = failed = 0

    for note_path in sorted(notes):
        text = note_path.read_text(encoding="utf-8")
        data, body = parse_frontmatter(text)

        if data is None:
            print(f"  – {note_path.name}: no frontmatter, skipping")
            skipped += 1
            continue

        # Skip if cover already present and not forcing
        if COVER_PROPERTY in data and data[COVER_PROPERTY] and not args.force:
            print(f"  ✓ {note_path.name}: cover already set, skipping")
            skipped += 1
            continue

        # Articles use `pdf:`, papers use `pdf:` / `File:` / `file:`
        pdf_value = data.get("pdf") or data.get("File") or data.get("file")
        pdf_path  = resolve_pdf_path(str(pdf_value), vault_root) if pdf_value else None

        if not pdf_path:
            print(f"  – {note_path.name}: no resolvable PDF path, skipping")
            skipped += 1
            continue

        img_name     = pdf_path.stem + "_cover.png"
        img_abs      = attach_dir / img_name
        img_wikilink = f"[[{(attach_dir / img_name).relative_to(vault_root)}]]"

        print(f"  → {note_path.name}")
        print(f"       PDF   : {pdf_path.name}")
        print(f"       Cover : {img_name}")

        if not extract_cover(pdf_path, img_abs):
            failed += 1
            continue

        data[COVER_PROPERTY] = img_wikilink
        note_path.write_text(serialise_frontmatter(data, body), encoding="utf-8")
        print(f"       ✓ written")
        updated += 1

    print(f"\nDone — {updated} updated, {skipped} skipped, {failed} failed")


if __name__ == "__main__":
    main()
