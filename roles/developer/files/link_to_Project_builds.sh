#!/usr/bin/env bash

# get project path after ~/Projects
# it will either get the part after Projects or the whole path
project_path="${PWD##*/Projects}"

# create directory for project files
parent_for_build_dirs="$HOME/Project_builds$project_path"

# target - maven and rustc
# out - Intellij Idea
# dist - JS projects
# build - I cant remember
build_dirs=(target out dist build)

# for each build_dir
for build_dir in "${build_dirs[@]}"; do

  # if a build dir exists
  build_dir_path="$PWD/$build_dir"
  if [[ -d $build_dir_path ]]; then

    # make sure parent directory for builds exists
    mkdir -p "$parent_for_build_dirs"

    # copy build dir to new location
    cp -r "$build_dir_path" "$parent_for_build_dirs"

    # remove old build_dir
    rm -r "$build_dir_path"

    # create symlink
    target="$parent_for_build_dirs/$build_dir"
    link_name="$build_dir_path"
    ln --symbolic --verbose "$target" "$link_name"
  fi
done
