#!/bin/sh

# optional argument 1 is filename, otherwise all relevant *.tex files

xslcmd="java -jar ${HOME}/.nix-profile/saxon-he-11.5.jar"

echo "processing xml …"
echo "… hp1"
$xslcmd -s:xml/HP1_text-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp1.html \
	chapid="hp1" \
	transl="../xml/HP1_comm-tei.xml" \
	marma="../xml/Marmasthanas-tei.xml" \
	jyotsna="../xml/jyotsna.xml"

echo "… hp2"
$xslcmd -s:xml/HP2_text-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp2.html \
	chapid="hp2" \
	transl="../xml/HP2_comm-tei.xml" \
	marma="../xml/Marmasthanas-tei.xml" \
	jyotsna="../xml/jyotsna.xml"

echo "… hp3"
$xslcmd -s:xml/HP3_text-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp3.html \
	chapid="hp3" \
	transl="../xml/HP3_comm-tei.xml" \
	marma="../xml/Marmasthanas-tei.xml" \
	jyotsna="../xml/jyotsna.xml"

echo "… hp4"
$xslcmd -s:xml/HP4_text-tei.xml -xsl:xslt/hp-online-pub.xsl -o:html/hp4.html \
	chapid="hp4" \
	transl="../xml/HP4_comm-tei.xml" \
	marma="../xml/Marmasthanas-tei.xml" \
	jyotsna="../xml/jyotsna.xml"

echo "concatenating html …"
sed '/<!--content-->/q' html/meta.html > html/hp-online-pub.html 

for f in "html/hp1.html" "html/hp2.html" "html/hp3.html" "html/hp4.html"
do
    sed -e '/^\s*$/d' $f >> html/hp-online-pub.html
done

sed -n '/<!--content-->/,$ {p}' html/meta.html >> html/hp-online-pub.html

#postprocess straddle consonants in 4line meteres
sed -i '/<p class="vers-line">.*-\s*<\/p>/{N}; x; s_-\(\s*</p>\s*<p class="vers-line">\s*\(<mark>\)\?\s*\)\([kgṅcjñṭḍṇtdnpbmyrlv]h\) _\3\1_g' html/hp-online-pub.html

exit
