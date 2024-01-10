#!/bin/sh
set -eu
fail(){ cat <<'EOF'

This project has these dependencies:

- basic unix tools

- https://github.com/ctarbide/coolscripts

    how to install:

        git clone https://github.com/ctarbide/coolscripts.git ~/Downloads/coolscripts

        # then add ~/Downloads/coolscripts/bin to your PATH



EOF
exit 1
}

command -v git-file-is-pristine.sh >/dev/null || fail

echo 'installation is ok'
