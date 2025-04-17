#!/bin/bash

author_name="$1"
repo_path="$2"

echo $author_name
echo $repo_path

cd "$repo_path" || exit 1

git log --author="$author_name" --pretty=tformat: --numstat --since="1970-01-01T00:00:00Z"

git log --author="$author_name" --pretty=tformat: --numstat --since="1970-01-01T00:00:00Z" |
awk '
  NF == 3 { added += $1; deleted += $2; split($3, parts, "."); if (length(parts) > 1) { lang = parts[length(parts)]; lang_added[lang] += $1; lang_deleted[lang] += $2 } }
  END {
    printf "language_loc:\n";
    for (l in lang_added) {
      loc = lang_added[l] - lang_deleted[l]
      if (loc != 0) {
        printf "  %s: %d\n", l, loc
      }
    }
  }
'
echo "DONE"
cd - || exit 1
