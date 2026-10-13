#!/usr/bin/env bash

# target - maven and rustc
# out - Intellij Idea
# dist - JS projects
# build - gradle and JS project
# node_modules - node.js modules
build_dirs=(target out dist build node_modules)

is_build_dir_name() {
  local name
  for name in "${build_dirs[@]}"; do
    [[ $name == "$1" ]] && return 0
  done
  return 1
}

# inside a git repo only ignored dirs are treated as build dirs,
# so a source dir (e.g. a java package) named 'build' is left alone
is_tracked_by_git() {
  local parent="${1%/*}"
  git -C "$parent" rev-parse --is-inside-work-tree &>/dev/null || return 1
  ! git -C "$parent" check-ignore --quiet "$1"
}

link_build_dir() {
  local build_dir_path="$1"

  # get project path after ~/Projects
  # it will either get the part after Projects or the whole path
  local target="$HOME/Project_builds${build_dir_path##*/Projects}"

  printf "build dir '%s' found... " "$build_dir_path"

  if [[ -L $build_dir_path ]]; then
    printf "but it was already linked, skipping\n"
    return
  fi

  if is_tracked_by_git "$build_dir_path"; then
    printf "but it is not ignored by git, skipping\n"
    return
  fi

  # a real build dir in the project wins over whatever is left in the target
  if [[ -e $target || -L $target ]]; then
    printf "replacing existing '%s'... " "$target"
    rm -rf -- "$target" || return
  fi

  # make sure parent directory for builds exists
  mkdir -p "${target%/*}" || return

  # move build dir to new location
  mv "$build_dir_path" "$target" || return

  # create symlink
  ln --symbolic "$target" "$build_dir_path" || return

  printf "linked to '%s'\n" "$target"
}

# link build dirs found in the given dir, then do the same for all its
# other subdirs (hidden dirs and symlinks are not followed)
process_dir() {
  local dir="$1"
  local entry

  for entry in "$dir"/*/; do
    # strip trailing slash added by the glob
    entry="${entry%/}"

    # glob did not match anything
    [[ -e $entry ]] || continue

    if is_build_dir_name "${entry##*/}"; then
      link_build_dir "$entry"
    elif [[ ! -L $entry ]]; then
      process_dir "$entry"
    fi
  done
}

process_dir "$PWD"
