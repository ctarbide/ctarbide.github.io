#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .nw
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu
exit 1

\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    urlcolor=blue,
    linkcolor=blue,
    citecolor=red,
    pdftitle={Hello World},
    pdfpagemode=FullScreen,
}
\usepackage{multicol}
\usepackage{noweb}
\pagestyle{noweb}
\noweboptions{shift}
\title{Hello world!}
\author{Cungsten Tarbide}
\begin{document}
\maketitle
\tableofcontents

\section{Hello Section!}

Hello live literate program!


\section{References}

\begin{itemize}
\item \href{https://github.com/ctarbide/coolscripts/blob/master/bin/nofake.nw}{nofake.nw} and
    \href{https://raw.githubusercontent.com/ctarbide/coolscripts/master/bin/nofake.pdf}{nofake.pdf}
    for \LaTeX{} tips.
\item \url{https://github.com/ctarbide/ctweb}
\item \url{https://github.com/thomasWeise/docker-texlive}
\end{itemize}

\section{Configuration}

<<nwmac.tex>>=
${HOME}/texmf/tex/plain/local/nwmac.tex
@

<<noweb.sty>>=
${HOME}/texmf/tex/latex/local/noweb.sty
@

\section{Program Chunk}

This is referenced by \hyperlink{scriptpreamble}{script preamble}.

<<prog>>=
thisprog=${1}; shift
perl -lne'last if m{^\s*$};}{while(<>){chomp;print}' -- \
    "${thisprog}" >"${0}.nw"
(
    printf -- '\\section{Script Preamble}\n\n'
    printf -- '\hypertarget{scriptpreamble}{%s}.\n\n' \
        'This is where it all begins'
    printf -- '@<<script preamble>>=\n'
    perl -lne'last if m{^\s*$};print' -- "${thisprog}"
    printf -- '@\n\n'
) >>"${0}.nw"
nofake -R'document footer' "${thisprog}" >>"${0}.nw"
noweave -delay -index -latex "${0}.nw" >hello-pdf.tex
docker-cwd.sh --rm -v "`pwd`:/doc" \
    -v "<<nwmac.tex>>:/texmf/tex/plain/local/nwmac.tex" \
    -v "<<noweb.sty>>:/texmf/tex/latex/local/noweb.sty" \
    thomasweise/texlive \
    sh -eux -c 'texhash /texmf; latexmk -pdf hello-pdf'
@

\section{Document Footer}

<<document footer>>=
\bibliographystyle{plain}
\bibliography{web}

\section{List of all chunks}
\nowebchunks

\end{document}
@
