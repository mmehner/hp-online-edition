# hp-online-edition
Static web rendering routine for the Haṭhapradīpikā-editing project.

## Prerequisites
- up-to-date [TeX Live installation](https://tug.org/texlive/acquire-netinstall.html),
- XSLT 2.0-processor like [Saxon-HE](http://saxon.sourceforge.net/#F9.9HE),
- sed.

## Usage
- Inspect: refer to rendering of [hp-online.html](html/hp-online.html) over [here](https://raw.githack.com/mmehner/hp-online-edition/master/html/hp-online.html).
- Recreate:
  1. change variable `xslcmd` in [compile-tidyup.sh](./compile-tidyup.sh) to suite your xslt 2 processor,
  2. run [compile-tidyup.sh](./compile-tidyup.sh).
- Change styling: refer to [style.css](html/style.css).  

## Known issues
- [ekdosis](https://ctan.org/pkg/ekdosis) is still in development, it might take some time until all features can be utilized to its full potential which should replace some of the workarounds.
