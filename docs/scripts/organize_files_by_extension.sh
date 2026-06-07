#!/usr/bin/env bash
# organize_files_by_extension.sh — Organize files by extension (with optional recursion and cleanup)
# Compatible with Linux, macOS, and Termux
# -r  Recursively organize files inside subdirectories
# --clean  Delete empty folders after organizing
# -h, --help  Show usage info

set -e

usage() {
    echo "Usage: $0 [-r] [--clean] <directory>"
    echo
    echo "  -r         Recurse into subdirectories"
    echo "  --clean    Delete empty folders after organizing"
    echo
    exit 1
}

# --- Parse options ---
RECURSIVE=false
CLEANUP=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r)
            RECURSIVE=true
            shift
            ;;
        --clean)
            CLEANUP=true
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            ;;
        *)
            TARGET_DIR="${1%/}"
            shift
            ;;
    esac
done

if [ -z "$TARGET_DIR" ]; then
    usage
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory '$TARGET_DIR' not found!"
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

echo "📁 Organizing files in: $TARGET_DIR"
$RECURSIVE && echo "🔁 Recursive mode enabled"
$CLEANUP && echo "🧹 Cleanup of empty folders enabled"

# --- Core function ---
organize_files() {
    local search_dir="$1"
    local recursive="$2"
    local find_opts=()

    if $recursive; then
        find_opts=(-type f)
    else
        find_opts=(-maxdepth 1 -type f)
    fi

    while IFS= read -r -d '' file; do
        [ -d "$file" ] && continue

        ext="${file##*.}"
        ext="${ext,,}"  # to lowercase
        dest="${CATEGORIES[$ext]:-others}"
        dest_path="$TARGET_DIR/$dest"

        mkdir -p "$dest_path"
        echo "📂 $(basename "$file") → $dest/"
        mv -n "$file" "$dest_path/" 2>/dev/null || echo "Failed to move: $file"
    done < <(find "$search_dir" "${find_opts[@]}" -print0)
}

organize_files "$TARGET_DIR" $RECURSIVE

if $CLEANUP; then
    echo "🧹 Removing empty folders..."
    find "$TARGET_DIR" -type d -empty -not -path "$TARGET_DIR" -delete
fi

echo "Done organizing files."
