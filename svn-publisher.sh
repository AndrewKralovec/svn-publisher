#!/bin/bash

##### Arguments
<<MAIN_ARGUMENTS
  Parse arguments a
  Set script flags (BRANCH_LIST, REPO_BASE_URL)
  @param {string}, number of arguments
MAIN_ARGUMENTS
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "svn-publisher - Merging and Publishing script"
      echo " "
      echo "svn-publisher [options]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-b, --branches            specify what branches to merge"
      echo "-r, --repo                specify the remote repo url for the project"
      exit 0
      ;;
    -b|--branches)
      shift
      if test $# -gt 0; then
        export BRANCH_LIST=$1
      fi
      shift
      ;;
    -r|--repo)
      shift
      if test $# -gt 0; then
        export REPO_BASE_URL=$1
      fi
      shift
      ;;
    *)
      break
      ;;
  esac
done

##### Functions
<<FUNCTION_GET_REMOTE_URL
  Get the local repos remote url. Used to fetch the branches
  This value can be overwritten by the ENV or as an argument
  @returns {string}, remote repo
FUNCTION_GET_REMOTE_URL
get_remote_url() {
  if [[ -z "$REPO_BASE_URL" ]]; then
    echo "$(svn info | grep 'Repository Root' | awk '{print $NF}')"
  else
    echo "$REPO_BASE_URL"
  fi
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

# TODO: Handle this in the argument parser
if [[ -z "$BRANCH_LIST" ]]; then
  # Combac: Refactor when trunk logic is ready
  # Later there will be an option to be a branch and merge in trunk if no branches specifed
  # TODO: Swap out the exit with trunk setting logic
  echo "No branches specified"
  exit 1
fi

repo_source_url="$(get_remote_url)"
for target_name in ${BRANCH_LIST[@]};
do
  merge_branch $repo_source_url $target_name
  commit_branch $repo_source_url $target_name
  clean_local
done
