upgrade-all() {
    _qc-upd() {
        if (( $+commands[$1] )) {
            echo ">>> $@ <<<"
            $@
        }
    }
    _qc-upd rustup update
    _qc-upd cargo install-update --all
}


#function gpr() {
#  local username=$(git config user.name)
#  if [ -z "$username" ]; then
#    echo "Please set your git username"
#    return 1
#  fi
#  local origin=$(git config remote.origin.url)
#  if [ -z "$origin" ]; then
#    echo "No remote origin found"
#    return 1
#  fi
#  local remote_username=$(basename $(dirname $origin))
#  if [ "$remote_username" != "$username" ]; then
#    local new_origin=${origin/\/$remote_username\//\/$username\/}
#    new_origin=${new_origin/https:\/\/github.com\//git@github.com:/}
#    git config remote.origin.url $new_origin
#    git remote remove upstream > /dev/null 2>&1
#    git remote add upstream $origin
#  fi
#  git checkout -b "pr-$(openssl rand -hex 4)"
#}
