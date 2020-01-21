# svn-publisher

SVN merging and publishing script

## Usage

Merging in a branch list

```sh
sh svn-publisher.sh -b "branch_1 branch_2"
```

Creating a PR branch, to test branch changes before merge to `/trunk`

```sh
./svn-branch-cp.sh "PR_TEST_BRANCH";
./svn-publisher.sh -p "$REPO_LOCAL_PATH" -b "branch_1 branch_2";
```

## Notes

The script assumes that a local copy of the branch/trunk, exists on the machine.
Why, you may ask. Legacy applications can be huge, and may take a long time to
copy to the machine.
