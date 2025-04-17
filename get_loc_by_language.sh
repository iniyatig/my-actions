#!/bin/bash

author_name="$1"
repo_path="$2"

cd "$repo_path" || exit 1

# Define variables
declare -A lang_added
declare -A lang_deleted

# Process git log output
git log --author="$author_name" --pretty=tformat: --numstat --since="1970-01-01T00:00:00Z" | while read -r added deleted filename; do
  if [ -n "$added" ] && [ -n "$deleted" ] && [ -n "$filename" ]; then
    # Extract file extension
    extension="${filename##*.}"
    if [ "$extension" != "$filename" ]; then
      # Update added and deleted counts per language
      lang_added["$extension"]=$((lang_added["$extension"] + added))
      lang_deleted["$extension"]=$((lang_deleted["$extension"] + deleted))
    fi
  fi
done

# Print formatted output
echo "language_loc:"
for lang in "${!lang_added[@]}"; do
  loc=$((lang_added["$lang"] - lang_deleted["$lang"]))
  if [ "$loc" -ne 0 ]; then
    echo "  $lang: $loc"
  fi
done

echo "DONE"
cd - || exit 1
