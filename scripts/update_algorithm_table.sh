#!/usr/bin/env bash
# Regenerates the "Implemented Algorithms" table in README.md from the
# L<lecture>/<Task> directory structure. Safe to run any time.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
README="$REPO_ROOT/README.md"
MARK_START='<!-- ALGORITHMS:START -->'
MARK_END='<!-- ALGORITHMS:END -->'

if [ ! -f "$README" ]; then
    echo "Error: README.md not found at $README" >&2
    exit 1
fi

if ! grep -qF "$MARK_START" "$README" || ! grep -qF "$MARK_END" "$README"; then
    echo "Error: README.md is missing the $MARK_START / $MARK_END markers." >&2
    exit 1
fi

# Build the table body.
TABLE=$'| Lecture | Task | Implemented Algorithm(s) | Location |\n'
TABLE+=$'| :--- | :--- | :--- | :--- |\n'

shopt -s nullglob
task_dirs=("$REPO_ROOT"/L*/)
count=0
for lecture_dir in "${task_dirs[@]}"; do
    lecture="$(basename "$lecture_dir")"
    for task_dir in "$lecture_dir"*/; do
        count=$((count + 1))
        task="$(basename "$task_dir")"
        if [ -f "$task_dir/algorithms.txt" ]; then
            algos="$(awk 'BEGIN{ORS=""} !/^[[:space:]]*$/{printf "%s%s", sep, $0; sep=", "}' \
                "$task_dir/algorithms.txt")"
            [ -n "$algos" ] || algos="$task"
        else
            algos="$task"
        fi
        rel="${task_dir#"$REPO_ROOT"/}"
        TABLE+="| $lecture | $task | $algos | [\`$rel\`]($rel) |"$'\n'
    done
done
shopt -u nullglob

if [ "$count" -eq 0 ]; then
    echo "Warning: no L<lecture>/<Task> folders found; table will be empty." >&2
fi

# Replace everything between the markers in README.md.
TMP="$README.tmp"
awk -v start="$MARK_START" -v end="$MARK_END" -v table="$TABLE" '
    $0 == start { print; printf "%s", table; inblock = 1; next }
    $0 == end   { inblock = 0; print; next }
    !inblock    { print }
' "$README" > "$TMP" && mv "$TMP" "$README"

echo "Updated algorithm table in README.md ($count task(s) found)."
