#!/bin/sh

xslcmd="java -jar  ${HOME}/Software/saxon9he.jar"

echo "processing xml …"
echo "… hp1"
    $xslcmd -s:xml/HP1_pub-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp1.html \
	    chapid="hp1" \
	    transl="../xml/HP1_comm-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… hp2"
    $xslcmd -s:xml/HP2_pub-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp2.html \
	    chapid="hp2" \
	    transl="../xml/HP2_comm-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… hp3"
    $xslcmd -s:xml/HP3_pub-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp3.html \
	    chapid="hp3" \
	    transl="../xml/HP3_comm-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… hp4"
    $xslcmd -s:xml/HP4_pub-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp4.html \
	    chapid="hp4" \
	    transl="../xml/HP4_comm-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… hpx4"
    $xslcmd -s:xml/HP4X_pub-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hpx4.html \
	    chapid="hpx4" \
	    transl="../xml/HP4_comm-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… Omega 1"
    $xslcmd -s:xml/omegamaster1-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hpomega1.html \
	    chapid="hpomega1" \
	    transl="../xml/HP1_comm-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… Omega 3"
    $xslcmd -s:xml/omegamaster3-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hpomega3.html \
	    chapid="hpomega3" \
	    transl="../xml/HP3_comm-tei.xml" \
	    jyotsna="../xml/jyotsna.xml"

    echo "… Omega Kj"
    $xslcmd -s:xml/omegamasterKj-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hpomegaKj.html \
	    chapid="hpomegaKj" \
	    transl="../xml/Kalajnana_comm-tei.xml"  \
	    jyotsna="../xml/jyotsna.xml"

    echo "concatenating hp omega …"
    
    printf "<div id=\"hpomega\" class=\"altrec\">\n" > html/hpomega.html
    for f in "html/hpomega1.html" "html/hpomega3.html" "html/hpomegaKj.html"
    do
	sed -e '/^\s*$/d' $f >> html/hpomega.html
    done
    printf "\n</div>" >> html/hpomega.html
    
echo "concatenating html …"
sed '/<!--content-->/q' html/meta.html > html/hp-online-pub.html 

for f in "html/hp1.html" "html/hp2.html" "html/hp3.html" "html/hp4.html" "html/hpx4.html" "html/hpomega.html"
do
    sed -e '/^\s*$/d' $f >> html/hp-online-pub.html
done

sed -n '/<!--content-->/,$ {p}' html/meta.html >> html/hp-online-pub.html

#postprocess straddle consonants in 4line meteres
sed -i '/<p class="vers-line">.*-\s*<\/p>/{N}; x; s_-\(\s*</p>\s*<p class="vers-line">\s*\(<mark>\)\?\s*\)\([kgṅcjñṭḍṇtdnpbmyrlv]h\) _\3\1_g' html/hp-online-pub.html

exit
