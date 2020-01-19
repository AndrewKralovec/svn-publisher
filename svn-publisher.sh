#!/bin/bash

##### Functions

<<FUNCTION_GET_LOCAL_REPO_URL
    Get the local repos remote url. Used to fetch the branches
    @returns {string}, remote repo
FUNCTION_GET_LOCAL_REPO_URL
get_local_repo_url() {
  echo "$(svn info | grep 'Repository Root' | awk '{print $NF}')"
}

<<FUNCTION_GET_BRANCH_LOGS
    Get the to target branch message logs, since branch was created
    @param {string} $1, source branch url
    @param {string} $2, target branch name
    @returns {string}, list of commit messages from target branch
FUNCTION_GET_BRANCH_LOGS
get_branch_logs() {
  echo "$(svn log --stop-on-copy $1/branches/$2)"
}

<<FUNCTION_GET_BRANCH_LOGS
    Merge the target branch to the source branch
    @param {string} $1, source branch url
    @param {string} $2, target branch name
    @returns {string}, merge result
FUNCTION_GET_BRANCH_LOGS
merge_branch() {
  echo "$(svn merge $1/branches/$2)"
}

##### Main Script

# TODO: make url configurable
REPO_BASE_URL="$(get_local_repo_url)"
merge_branch $REPO_BASE_URL $1
svn commit -m "$(get_branch_logs $REPO_BASE_URL $1)"
