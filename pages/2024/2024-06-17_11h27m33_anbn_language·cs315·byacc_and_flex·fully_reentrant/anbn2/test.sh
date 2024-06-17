#!/bin/sh
set -eu
make
echo | ./anbn         # expected: rule 0 match, is in anbn.
echo ab | ./anbn      # expected: rule 0 match, is in anbn.
echo aabb | ./anbn    # expected: rule 0 match, is in anbn.
echo aaabbb | ./anbn  # expected: rule 0 match, is in anbn.
