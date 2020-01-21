PR_BRANCH_NAME=${1:-"pull_request_preview"}
PR_MESSAGE=${2:-"Creating a PR branch for /app/trunk."}

# NOTE: Svn requires to be in the working dir to execute.
if [[ ! -z "$REPO_LOCAL_PATH" ]]; then
  cd "$REPO_LOCAL_PATH";
fi

# TODO: Fix code repeat
get_remote_url() {
  if [[ -z "$REMOTE_BASE_URL" ]]; then
    echo "$(svn info | grep 'Repository Root' | awk '{print $NF}')"
  else
    echo "$REMOTE_BASE_URL"
  fi
}

repo_source_url="$(get_remote_url)"
# Create a pr branch to merge and test changes from bugs
svn copy $repo_source_url/branches/trunk \
           $repo_source_url/branches/$PR_BRANCH_NAME \
           -m "$PR_MESSAGE"

# Switch to that branch when dotnet
# TODO: Make configurable
svn switch $repo_source_url/branches/$PR_BRANCH_NAME
