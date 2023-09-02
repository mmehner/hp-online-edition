#!/bin/sh
marma_tex=marma.tex
sig_txt=Sigla-Liste.txt

tsvmarma() { 
    sed -e 's_\\sthana_\\end{sthana}\n\\begin{sthana}_' ${marma_tex} |
	sed -n '/\\begin{sthana}{[a-z0-9]/,/\\end/ {p}' |
	sed -e 's_\s\+_ _g' \
	    -e 's_\\begin{sthana}{\([^}]*\)}_#\1\&_' |
	tr '\n' ' ' |
	sed -e 's_#_\n#_g'  \
	    -e ':a; s_([^()]*)_ _g; t a' \
	    -e 's_\\begin{[^}]*}\(\[[^]]*\]\)\?__g' \
	    -e 's_\\item\[[^]]*\]__g' \
	    -e 's_\\end{[^}]*}__g' \
	    -e 's_[%{},;] *_ _g' \
	    -e 's_ \+_ _g' |
	sed -e '/^\s*$/d' > marma.tsv 
}

mapfile -t siga < $sig_txt
tsvmarma
mapfile -t marmaa < marma.tsv

printf "Uncollated MSS per \\sthana-command:\n\n"

for ((i=0; i<${#marmaa[@]}; i+=1)); do
    printf "${marmaa[$i]}\n" | cut -d"&" -f1

    for ((j=0; j<${#siga[@]}; j+=1)); do
	sig=" ${siga[j]} "
	if (! $(echo "${marmaa[$i]}\n" | cut -d"&" -f2 | grep -sq "$sig"))
	then
	    printf ' -%s\n' "$sig"
	fi
    done

    printf "\n"
    
done
