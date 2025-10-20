#!/usr/bin/env bash
# organize_files_by_extension.sh — Organize files by extension with verbose output
set -e

# --- Argument & directory checks ---
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="${1%/}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found!"
    exit 1
fi

# --- File type mappings ---
declare -A CATEGORIES=(
    # Audio
    [mp3]="audio" [flac]="audio" [wav]="audio" [aac]="audio" [ogg]="audio"

    # Video
    [mp4]="video" [mkv]="video" [mov]="video" [avi]="video" [webm]="video"

    # Documents
    [pdf]="docs/pdf"
    [docx]="docs/docx" [doc]="docs/docx"
    [txt]="docs/txt" [md]="docs/txt"
    [pptx]="docs/pptx" [ppt]="docs/pptx"
    [xlsx]="docs/xlsx" [xls]="docs/xlsx" [csv]="docs/xlsx"

    # Images
    [jpg]="images" [jpeg]="images" [png]="images" [gif]="images" [svg]="images" [webp]="images" [heic]="images"

    # Apps & executables
    [apk]="apps" [exe]="apps" [deb]="apps" [rpm]="apps" [AppImage]="apps"

    # Archives
    [zip]="archives" [tar]="archives" [gz]="archives" [rar]="archives" [7z]="archives" [bz2]="archives"

    # Code
    [py]="code" [c]="code" [cpp]="code" [java]="code" [js]="code" [html]="code" [css]="code" [sh]="code" [json]="code"
)

mkdir -p "$TARGET_DIR"
shopt -s nullglob

# --- Main loop ---
for file in "$TARGET_DIR"/*; do
    [ -d "$file" ] && continue

    ext="${file##*.}"
    ext="${ext,,}"  # lowercase
    dest="${CATEGORIES[$ext]:-others}"
    dest_path="$TARGET_DIR/$dest"

    mkdir -p "$dest_path"

    echo "📂 Moving: $(basename "$file") → $dest/"
    mv "$file" "$dest_path/" 2>/dev/null || echo "⚠️  Failed to move: $file"
done

echo "✅ Files organized successfully in '$TARGET_DIR'"
