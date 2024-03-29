#!/bin/sh

# optional argument 1 is filename, otherwise all relevant *.tex files

xslcmdproc(){
    xslcmd="java -jar ${HOME}/.nix-profile/saxon-he-11.5.jar"

    echo "processing xml …"
    echo "… hp1"
    $xslcmd -s:xml/HP1_text-tei.xml -xsl:xslt/hp-online.xsl -o:html/hp1.html \
	    chapid="hp1" \
	    transl="../xml/HP1_comm-tei.xml" \
	    marma="../xml/Marmasthanas-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… hp2"
    $xslcmd -s:xml/HP2_text-tei.xml -xsl:xslt/hp-online.xsl -o:html/hp2.html \
	    chapid="hp2" \
	    transl="../xml/HP2_comm-tei.xml" \
	    marma="../xml/Marmasthanas-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… hp3"
    $xslcmd -s:xml/HP3_text-tei.xml -xsl:xslt/hp-online.xsl -o:html/hp3.html \
	    chapid="hp3" \
	    transl="../xml/HP3_comm-tei.xml" \
	    marma="../xml/Marmasthanas-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… hp4"
    $xslcmd -s:xml/HP4_text-tei.xml -xsl:xslt/hp-online.xsl -o:html/hp4.html \
	    chapid="hp4" \
	    transl="../xml/HP4_comm-tei.xml" \
	    marma="../xml/Marmasthanas-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "concatenating html …"
    sed '/<!--content-->/q' html/meta.html > html/hp-online.html 
    
    for f in "html/hp1.html" "html/hp2.html" "html/hp3.html" "html/hp4.html"
    do
	sed -e '/^\s*$/d' $f >> html/hp-online.html
    done
    
    sed -n '/<!--content-->/,$ {p}' html/meta.html >> html/hp-online.html

    #postprocess straddle consonants in 4line meteres
    sed -i '/<p class="hpvers">.*-\s*<\/p>/{N}; x; s_-\(\s*</p>\s*<p class="hpvers">\s*\(<mark>\)\?\s*\)\([kgṅcjñṭḍṇtdnpbmyrlv]\) _\3\1_g' html/hp-online.html 
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

    latexmk -c
    popd || exit
}

xmlizejyotsna(){
    echo "<TEI xmlns=\"http://www.tei-c.org/ns/1.0\"><teiHeader/><body><text>" > xml/jyotsna.xml

    sed -e '1,/\\startlinenumbering/ {d}' \
    -e '/\\begin{vsid}{#hp03_001}/,$ {d}' \
    -e 's_%*\\begin{vsid}{\(.*\)}_<note type="jyotsna" target="\1">_' \
    -e 's_%*\\end{vsid}_</note>_' \
    -e 's_%.*__' \
    -e 's_\s\+$__g' \
    latex/Jyotsna.tex |
    tr '\n' '\0' |
    sed -e 's_\\ \+__g' \
	-e 's_\\-__g' \
	-e 's_\\blank__g' \
	-e 's_\\[a-z]*{[^{}]*}__g' \
	-e 's_{[^{}]\+}__g' \
	-e 's_\\[a-z]*{[^{}]*}__g' |
    tr '\0' '\n' |
    sed -e '/{\\bf/,/)}/ {d}' \
	-e '/\\startsloka/,/\\stopsloka/ {
	s_\\startsloka_<lg>_
       	s_\\stopsloka_</lg>_
       	s_\(^[^<].\+\)_<l>\1</l>_
	}' >> xml/jyotsna.xml

    echo "</text></body></TEI>" >> xml/jyotsna.xml
}


if [ -f "latex/${1}" ]
then
    echo "found $1"
    rm "latex/${1%.*}.pdf"
    compile "${1#*/}"
elif [ -z "${1:-}" ]
then
    for f in "HP1_text.tex" "HP2_text.tex" "HP3_text.tex" "HP4_text.tex" "HP1_comm.tex" "HP2_comm.tex" "HP3_comm.tex" "HP4_comm.tex" "Marmasthanas.tex" 
    do
	echo "compiling ${f} …"
	compile "${f}"
    done
fi
xmlizejyotsna 
xslcmdproc

exit
