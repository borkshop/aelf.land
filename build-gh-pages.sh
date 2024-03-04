#!/bin/bash
set -eu -o pipefail

HERE=$(cd -L $(dirname -- $0); pwd)
export PATH="$HERE/node_modules/.bin":"$PATH"

function gen_matrix_wk() {
    echo "100644 blob $(git hash-object -w well-known/matrix-client)"$'\t'"client"
    echo "100644 blob $(git hash-object -w well-known/matrix-server)"$'\t'"server"
    echo "100644 blob $(git hash-object -w well-known/matrix-support)"$'\t'"support"

}
function gen_well_known() {
    echo "040000 tree $(gen_matrix_wk | git mktree)"$'\t'"matrix"
}

function gentree() {
    echo "100644 blob $(git hash-object -w <(bundle index.js))"$'\t'"bundle.js"
    echo "100644 blob $(git hash-object -w index.css)"$'\t'"index.css"
    echo "100644 blob $(git hash-object -w bundle.html)"$'\t'"index.html"
    echo "100644 blob $(git hash-object -w CNAME)"$'\t'"CNAME"

    echo "040000 tree $(gen_well_known | git mktree)"$'\t'".well-known"
}

TREE=$(gentree | git mktree)
COMMIT=$(git commit-tree $TREE < <(echo Create bundles))
git update-ref refs/heads/gh-pages $COMMIT
