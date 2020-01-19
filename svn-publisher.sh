#!/bin/bash

##### Args
# ARG1=${1:-foo}
# myArray=("$@")
# for arg in "${myArray[@]}"; do
#    echo "in $arg"
# done

##### COMMANDS

# svn info | grep 'Repository Root' | awk '{print $NF}')
# svn log --stop-on-copy
# svn merge
# svn copy <https://subversion.assembla.com/svn/path/to/trunk> \
#          <https://subversion.assembla.com/svn/path/to/branch_name> \
#          -m "commit message"

get_local_repo_url() {
  local repo_url="$(svn info | grep 'Repository Root' | awk '{print $NF}')"
  echo "$repo_url"
}

##### Main
echo "$(svn info | grep 'Repository Root' | awk '{print $NF}')"
get_local_repo_url
