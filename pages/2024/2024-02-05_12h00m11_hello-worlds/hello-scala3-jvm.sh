#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh -eu}; export SH
thisprog=${0##*/} tmp=${0%/*} thisdir=${tmp#${thisprog}} prfx=${thisprog%.sh}
mkdir -p "${prfx}.dir"
P="${prfx}" exec nofake-exec.sh --error -Rprog "$@" -o"${prfx}.dir/${prfx}.scala" -- ${SH} -c '
    prfx=${P}; unset P
    cd "${prfx}.dir"
    scalac.sh "${prfx}.scala"
    # exec scala.sh java "${prfx}"
    exec scala.sh java run
' --
exit 1

This is a live literate program.

<<tested with versions>>=
- Welcome to Scala 3.7.4 (17.0.15, Java OpenJDK 64-Bit Server VM).
@

<<see also>>=
- https://github.com/ctarbide/java-scripting

    - provides `scala.sh`, `scalac.sh` and `scala-repl.sh`

@

<<prog>>=
@main def run(): Unit =
  print("hello world!")
  println()
@
