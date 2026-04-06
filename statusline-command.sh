#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
dir=$(basename "$cwd")

# Git branch and dirty state
branch=""
dirty=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
    dirty=" \033[33m✗\033[0m"
  fi
fi

# Arrow: robbyrussell uses green arrow
arrow="\033[1;32m➜\033[0m"

# Directory in cyan
dir_part="\033[36m${dir}\033[0m"

# Git part in blue/red
if [ -n "$branch" ]; then
  git_part=" \033[1;34mgit:(\033[31m${branch}\033[1;34m)\033[0m${dirty}"
else
  git_part=""
fi

printf "${arrow} ${dir_part}${git_part}"
