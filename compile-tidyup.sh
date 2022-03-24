#!/bin/sh

# optional argument 1 is filename, otherwise all relevant *.tex files

xslcmd="java -jar /usr/share/java/saxon/saxon9he.jar -s:xml/HP1_OldMss-tei.xml -xsl:xslt/hp-online.xsl"

xslcmdproc(){
    ${xslcmd} | \
	sed "/^\s*$/d" \
	    > html/hp-online.html 
}

compile(){
    pdf="${1%.*}.pdf"
    tei="${1%.*}-tei.xml"
    
    pushd  "latex" || exit

    if [ "${1}" -nt "${pdf}" ]
    then
	latexmk -lualatex "${1}"
	
	sed -i \
	    -e "s_</\?lg[^>]*>_\n&\n_g" \
	    -e "s_</l>\s*<l>_</l>\n<l>_g" \
	    -e "s_</note>_&\n_g" \
    	    -e "s_</?item>_&\n_g" \
	    -e "s_</?list>_&\n_g" \
	    -e "s_\\\\[+!]\?__g" \
	    -e "s_'_’_g" \
	    "${tei}"

	cp  -v "${tei}" ../xml/
    else
	echo "No changes to ${1}, skipping compilation."
    fi

    popd || exit
}


if [ -f "${1}" ]
then
    compile "${1#*/}"
elif [ -z "${1:-}" ]
then
    for f in "HP1_OldMss.tex" "HP1-TranslComm.tex" "Jyotsna.tex" "Marmasthanas.tex"
    do
	compile "${f}"
    done
fi
xslcmdproc

exit
