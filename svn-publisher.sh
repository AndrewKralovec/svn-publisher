#!/bin/bash

##### Functions
get_local_repo_url() {
  echo "$(svn info | grep 'Repository Root' | awk '{print $NF}')"
}

get_branch_logs() {
  echo "$(svn log --stop-on-copy $1/branches/$2)"
}

merge_branch() {
  echo "$(svn merge $1/branches/$2)"
}

##### Main

# TODO: make url configurable
# Get the source branch url
REPO_BASE_URL="$(get_local_repo_url)"
# Merge target branch to local repo
merge_branch $REPO_BASE_URL $1
# Commit the merge, with the messages from the other branch
svn commit -m "$(get_branch_logs $REPO_BASE_URL $1)"
