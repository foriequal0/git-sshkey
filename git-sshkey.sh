#!/bin/bash

GIT_DIR=`git rev-parse --git-dir`
PKEY_NAME=`git config user.pkey`
if [ -z "$PKEY_NAME" ]; then
	PKEY=""
else
	PKEY="$GIT_DIR/$PKEY_NAME"
fi

TMP_GIT_CMD=`mktemp`
trap "rm -f $TMP_GIT_CMD" EXIT

cat <<"EOF" > "$TMP_GIT_CMD"
#!/bin/bash
if [ -z "$PKEY" ]; then
	ssh "$@"
else
	ssh -i "$PKEY" "$@"
fi
EOF
chmod +x "$TMP_GIT_CMD"

PKEY="$PKEY" \
GIT_SSH="$TMP_GIT_CMD" \
git "$@"
