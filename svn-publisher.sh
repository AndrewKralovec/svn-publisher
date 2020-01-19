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

<<FUNCTION_MERGE_BRANCH
    Merge the target branch to the source branch
    @param {string} $1, source branch url
    @param {string} $2, target branch name
    @returns {string}, merge result
FUNCTION_MERGE_BRANCH
merge_branch() {
  echo "$(svn merge $1/branches/$2)"
}

<<FUNCTION_COMMIT_BRANCH
    Commit the merge using the target branches logs
    @param {string} $1, source branch url
    @param {string} $2, target branch name
FUNCTION_COMMIT_BRANCH
commit_branch() {
  # TODO: make the commit/messages configurable
  svn commit -m "$(get_branch_logs $1 $2)"
}

<<FUNCTION_CLEAN_LOCAL
    Run svn clean up methods once the merging is finished
FUNCTION_CLEAN_LOCAL
clean_local() {
  svn cleanup
  svn update
}

##### Main Script
REPO_BASE_URL="$(get_local_repo_url)"
# Merge and commit branches from args
for branch_name in "$@"
do
  merge_branch $REPO_BASE_URL $branch_name
  commit_branch $REPO_BASE_URL $branch_name
  clean_local
done
