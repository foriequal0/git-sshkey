#!/bin/bash

function version_compare(){
	local LEFT=$1
	local RIGHT=$2

	if [[ $LEFT == $RIGHT ]]; then
		echo '='
	fi
	local SMALLER=`echo "$LEFT $RIGHT" |tr ' ' '\n' | sort -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 -g | head -n1`
	if [[ $LEFT == $SMALLER ]]; then
		echo '<'
	else
		echo '>'
	fi
}

function do_with_git_ssh(){
	local PKEY=$1
	shift;
	local ARGS=$@
	local TMP_GIT_CMD=`mktemp /tmp/git_ssh.XXXXXX`
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

	GIT_SSH="$TMP_GIT_CMD" \
		PKEY="$PKEY" \
		git $ARGS
}

function do_with_git_ssh_command() {
	local PKEY=$1
	shift;
	local ARGS=$@

	GIT_SSH_COMMAND='ssh -i "$PKEY"'\
		PKEY="$PKEY" \
		git $ARGS
}

function do_git_sshkey() {
	local PKEY=$1
	shift;
	local ARGS=$@
	local GIT_VERSION=`git version | sed 's/git version //'`
	local CMP=$(version_compare "$GIT_VERSION" "2.3.0")
	case $CMP in
		">"|"=") 
			do_with_git_ssh_command "$PKEY" $ARGS;; 
		"<")
			do_with_git_ssh "$PKEY" $ARGS;;
	esac
}

if [[ $# -lt 1 ]]; then
	echo "git sshkey: argument insufficient." > /dev/stderr
fi

GIT_DIR=`git rev-parse --git-dir`
PKEY_NAME=`git config user.pkey`
if [ -z "$PKEY_NAME" ]; then
	PKEY=""
	echo "git sshkey: user.pkey not set." > /dev/stderr
else
	PKEY="$GIT_DIR/$PKEY_NAME"
fi

do_git_sshkey "$PKEY" "$@"
