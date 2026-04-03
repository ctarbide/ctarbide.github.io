#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --suffix .js
SH=${SH:-sh -eu}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- ${SH} -c '
    prog=${1}; shift
    thisprog=${1}; shift
    #exec ~/showargs-nl nashorn.sh "${prog}" "$@"
    exec nashorn.sh "${prog}" -- "$@"
' --
exit 1

This is a live literate program.

<<tested with versions>>=
- 17.0.15, Java OpenJDK 64-Bit Server VM
- nashorn 15.6
@

<<see also>>=
- https://github.com/ctarbide/java-scripting

    - provides a `nashorn.sh`

@

<<prog>>=
const System = Java.type("java.lang.System");
const JavaString = Java.type("java.lang.String");

const println = s => System.out.println(s);

if (!Array.from) Array.from = x => [].slice.call(x);

println("hello world!");
const args = Array.from(arguments);
println(`args: ${JavaString.join(", ", args.map(x => `"${x}"`))}`);

var LogManager = Java.type('org.apache.logging.log4j.LogManager');
var LogManager_getLogger = Java.type('org.apache.logging.log4j.LogManager')['getLogger(String)'];

var LOG = LogManager_getLogger("hello-nashorn.sh");

LOG.trace("testing: {}", 'trace message');
LOG.debug("testing: {}", 'debug message');
LOG.info("testing: {}", 'info message');
LOG.warn("testing: {}", 'warn message');

LOG.info("current file name: {}", __FILE__);
