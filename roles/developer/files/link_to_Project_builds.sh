#!/usr/bin/env bash

# target - maven and rustc
# out - Intellij Idea
# dist - JS projects
# build - gradle and JS project
# node_modules - node.js modules
# .gradle - gradle distribution dir
build_dirs=(target out dist build node_modules .gradle)

projects_dir="$HOME/Projects"
builds_dir="$HOME/Project_builds"

# only work inside ~/Projects, anywhere else (e.g. ~ or /) this would
# move unrelated dirs that happen to have a build dir name
if [[ $PWD != "$projects_dir" && $PWD != "$projects_dir"/* ]]; then
  printf "'%s' is not inside '%s', aborting\n" "$PWD" "$projects_dir" >&2
  exit 1
fi

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

  # same path, but below ~/Project_builds instead of ~/Projects
  local target="$builds_dir${build_dir_path#"$projects_dir"}"

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
  local name entry

  # build dirs are looked up by name, so hidden ones (.gradle) are found too
  for name in "${build_dirs[@]}"; do
    [[ -d $dir/$name ]] && link_build_dir "$dir/$name"
  done

  # the glob does not match hidden dirs
  for entry in "$dir"/*/; do
    # strip trailing slash added by the glob
    entry="${entry%/}"

    # glob did not match anything
    [[ -e $entry ]] || continue

    # recurse into ordinary subdirs only: build dirs were handled above
    # (never look inside them) and symlinks could lead outside the project
    if ! is_build_dir_name "${entry##*/}" && [[ ! -L $entry ]]; then
      process_dir "$entry"
    fi
  done
}

process_dir "$PWD"
