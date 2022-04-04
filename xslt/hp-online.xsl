<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="xsl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:output method="xhtml"  encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
  
  <!-- templates -->
  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<title>Haṭhapradīpikā Online</title>
	<link href="style.css?rnd=132" rel="stylesheet" type="text/css"/>
      </head>
      <xsl:apply-templates select="TEI/text/body"/>
    </html>
  </xsl:template>

  <!-- if nothing else matches: identity transformation for text nodes -->
  <xsl:template match="text()">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

  <!-- deletions -->
  <xsl:template match="note[@type='altrecension']"/>
  <xsl:template match="note[@type='avataranika']"/>
  
  <!-- main template -->
  <xsl:template match="body">
    <body>
      <div id="content">
	<h1>Haṭhapradīpikā Online</h1>
	<xsl:apply-templates/>
      </div>
      </body>
  </xsl:template>
  
  <xsl:template match="lg[not(ancestor::note)]">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <div class="main">
      <div class="hpmeta">
	<div class="text">

	  <xsl:element name="div">
	    <xsl:attribute name="id">
	      <xsl:value-of select="@xml:id"/>
	    </xsl:attribute>
	    <xsl:attribute name="class">hp</xsl:attribute>
	    <span class="number">
	      <xsl:value-of select="replace(@xml:id, 'hp0*(\d+)_0*(\d+)', 'HP $1.$2')"/>
	    </span>
	    <div class="Adhishila">
	      <xsl:apply-templates select="//note[@type='avataranika' and @target=$correspkey]" mode="avataranika"/>
	      <xsl:apply-templates/>
	    </div>
	  </xsl:element>
	  
	  <div class="translation">
	    <xsl:apply-templates select="document('../xml/HP1-TranslComm-tei.xml')//note[@type='translation' and @target=$correspkey]"/>
	  </div>
	  
	  <details class="philcomm-d">
	    <summary>Philological Commentary</summary>
	    <div class="philcomm">
	      <xsl:apply-templates select="document('../xml/HP1-TranslComm-tei.xml')//note[@type='philcomm' and @target=$correspkey]"/>
	    </div>
	  </details>
	  
	</div>

	<div class="crit">
	  <div class="apparatus">
	    <h3>Readings</h3>
	      <xsl:for-each select="descendant::app">
		<xsl:call-template name="apparatus"/>
	      </xsl:for-each>
	    </div>
	    <details class="marma-d">
	      <summary>More Readings</summary>
	      <div class="marma">
		<xsl:apply-templates select="document('../xml/Marmasthanas-tei.xml')//note[@type='marma' and @target=$correspkey]"/>
	      </div>
	    </details>
	    <details class="sources-d">
	      <summary>Sources &amp; Testimonia</summary>
	      <div class="sources">
		<xsl:apply-templates select="document('../xml/HP1-TranslComm-tei.xml')//note[@type='sources' and @target=$correspkey]"/>
	      </div>
	    </details>
	  </div>
	</div>

	<details class="jyotsna-d">
	  <summary>Jyotsna Commentary</summary>
	  <div class="jyotsna">
	    <xsl:apply-templates select="document('../xml/Jyotsna-tei.xml')//note[@type='jyotsna' and @target=$correspkey]"/>
	  </div>
	</details>
    </div>
  </xsl:template>

  <xsl:template match="note" mode="avataranika">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!-- iast2nagari for text nodes of hp and avataranika -->
  <xsl:template match="l[not(ancestor::note)]//text()|note[@type='avataranika']//text()">
    <xsl:value-of select="replace(replace(
			  translate(
			  replace(replace(
			  translate(
			  replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(.,
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]) *([kgṅcjñṭḍṇtdnpbmyrlvśṣs])','$1्$2'),
			  '([r])([h])','$1्$2'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ai','$1ै'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)au','$1ौ'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)a','$1'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ā','$1ा'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)i','$1ि'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ī','$1ी'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)u','$1ु'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ū','$1ू'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ṛ','$1ृ'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ṝ','$1ॄ'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ḷ','$1ॢ'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)ḹ','$1ॣ'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)e','$1े'),
			  '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?)o','$1ो'),
			  '’', 'ऽ'),
			  'ṃ', 'ं'),
			  'ḥ', 'ः'),
			  'kh','ख'),
			  'gh','घ'),
			  'ch','छ'),
			  'jh','झ'),
			  'ṭh','ठ'),
			  'ḍh','ढ'),
			  'th','थ'),
			  'dh','ध'),
			  'ph','फ'),
			  'bh','भ'),
			  'kgṅcjñṭḍṇtdnpbmyrlvśṣshṃḥ','कगङचजञटडणतदनपबमयरलवशषसह'),
			  'ai','ऐ'),
			  'au','औ'),
			  'aāiīuūṛṝḷeo','अआइईउऊऋलृएओ'),
			  '//',' ॥'),
			  '/',' ।')"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- lemma-choice -->
  <xsl:template match="app[descendant::rdg] | app[descendant::lem]">
    <mark>
      <xsl:choose>
	<xsl:when test="lem">
	  <xsl:apply-templates select="lem/node()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="descendant::rdg[1]/node()"/>
	</xsl:otherwise>
      </xsl:choose>
    </mark>
  </xsl:template>

  <!-- apparatus -->
  <xsl:template name="apparatus">
    <div class="app">
      <xsl:choose>
	<xsl:when test="lem">
	    <xsl:apply-templates select="lem" mode="lemma"/>
	    <xsl:text> ]</xsl:text>
	    <xsl:text> </xsl:text>
	    <xsl:for-each select="descendant::rdg[not(position() = last())]">
	      <xsl:apply-templates select="."/><xsl:text>, </xsl:text>
	    </xsl:for-each>
	    <xsl:apply-templates select="descendant::rdg[position() = last()]"/>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:apply-templates select="descendant::rdg[1]" mode="lemma"/>
	    <xsl:text> ]</xsl:text>
	    <xsl:text> </xsl:text>
	    <xsl:for-each select="descendant::rdg[position() > 1][not(position() = last())]">
	      <xsl:apply-templates select="."/><xsl:text>, </xsl:text>
	    </xsl:for-each>
	    <xsl:apply-templates select="descendant::rdg[position() = last()]"/>
	</xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="lem|rdg" mode="lemma">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <span class="lem">
      <xsl:value-of select="."/>
    </span>
    <xsl:call-template name="sigla"/>
  </xsl:template>

  <xsl:template match="lem|rdg">
    <xsl:value-of select="."/>
    <xsl:call-template name="sigla"/>
  </xsl:template>

  <xsl:template name="sigla">
     <xsl:if test="@wit">
      <xsl:text> (</xsl:text>
      <xsl:variable name="tree" select="//*"/>
      <xsl:for-each select="tokenize(@wit,'\s+')">
	<xsl:variable name="token" select="."/>
	<xsl:if test="position()>=2">
	  <xsl:text> </xsl:text>
	</xsl:if>
	<xsl:choose>
	  <xsl:when test="starts-with(., '#')">
	    <xsl:variable name="idkey" select="substring-after(., '#')"/>
	    <xsl:element name="span">
	      <xsl:attribute name="class">siglum</xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="normalize-space($tree[@xml:id = $idkey])"/>
	      </xsl:attribute>
	      <xsl:value-of select="substring-after(., '#')"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="."/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- simple html equivalents -->  
  <xsl:template match="l[not(ancestor::note)]">
    <p class="hpvers"><xsl:apply-templates/></p>
  </xsl:template>

  
  <xsl:template match="p">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <!-- non-main stanzas -->
  <xsl:template match="lg[ancestor::note]">
    <div class="lg">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

   <xsl:template match="l[ancestor::note]">
    <p class="vers"><xsl:apply-templates/></p>
  </xsl:template>

  <!-- footnotes -->
  <xsl:template match="note[@place='bottom' or @type='myfn']">
    <xsl:element name="span">
      <xsl:attribute name="class">fn</xsl:attribute>
      <xsl:attribute name="title">
	<xsl:value-of select="."/>
      </xsl:attribute>
      <b>*</b>
    </xsl:element>
  </xsl:template>
  
  <!-- lists -->
  <xsl:template match="list">
    <ul class="list">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="list/label[following-sibling::item]">
    <li><span class="label"><xsl:apply-templates/>: </span>
    <xsl:value-of select="following-sibling::item[1]"/></li>
  </xsl:template>
  
  <xsl:template match="item[not(preceding-sibling::label)]">
    <li><xsl:apply-templates/></li>
  </xsl:template>

   <xsl:template match="item[preceding-sibling::label]"/>
  
  <!-- headings -->
  <xsl:template match="head">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>

  <!-- emphasis -->
  <xsl:template match="hi">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <!--deletions -->
  
</xsl:stylesheet>
