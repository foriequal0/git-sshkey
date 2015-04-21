git-sshkey
==========

Handy addon to handle per-repository ssh-key.

## How to use
Download script
```
wget https://raw.githubusercontent.com/foriequal0/git-sshkey/master/git-sshkey.sh -O ~/bin/git-sshkey
chmod +x ~/bin/git-sshkey
```

Create your ssh key to .git/somewhere/
```
ssh-keygen -t rsa -f .git/somewhere/id_rsa_my_per_repository_key
```

Set per-repository ssh key
```
git config user.pkey "somewhere/id_rsa_my_per_repository_key"
```

Set origin to ssh url
```
git remote set-url ssh://git@my-remote-git.com:account/my-proj.git
```

Use
```
git ssh push
git ssh pull
```

## Disclaimer

Tested with git 1.7.1, CentOS 6.6
