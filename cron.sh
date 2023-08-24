#!/bin/bash
set -x
# origin/branch we are interested in
origin="origin"
branch="main"
# last commit hash
commit=$(git log -n 1 --pretty=format:%H "$branch")

# url of the remote repo
url=$(git remote get-url "$origin")

for line in "$(git ls-remote -h $url)"; do
    fields=($(echo $line | tr -s ' ' ))
    if  [[ "${fields[0]}" == "$commit" ]] 
    then
        echo "Nothing new"
    else
        echo "New commit(s) availble"
        git pull
        ansible-galaxy install -r requirements.yml -f
        ansible-playbook -v -i inventory/all all.yml --skip-tags hardening
    fi
done

