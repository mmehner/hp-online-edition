<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns=""
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="xsl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:output method="xhtml"  encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>

  <!-- passed parameters -->
  <xsl:param name="chapid"/>
  <xsl:param name="transl"/>
  <xsl:param name="marma"/>
  <xsl:param name="jyotsna"/>
  
  <!-- templates -->
  <xsl:template match="/">
    <xsl:element name="div">
      <xsl:attribute name="id">
	<xsl:value-of select="$chapid"/>
      </xsl:attribute>
      <xsl:apply-templates select="TEI/text/body"/>
    </xsl:element>
  </xsl:template>

  <!-- if nothing else matches: identity transformation for text nodes -->
  <xsl:template match="text()">
    <xsl:copy/>
  </xsl:template>

  <!-- deletions -->
  <xsl:template match="note[@type='altrecension']"/>
  <xsl:template match="note[@type='avataranika']"/>
  <xsl:template match="note[@type='omission']"/>
  <xsl:template match="note[@type='memo']"/>
  
  <!-- main template -->
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
	    <div class="versdev">
	      <xsl:apply-templates select="//note[@type='avataranika' and @target=$correspkey]" mode="avataranika">
		<xsl:with-param name="transc" select="true()" tunnel="yes"/>
	      </xsl:apply-templates>
	      
	      <xsl:apply-templates>
		<xsl:with-param name="transc" select="true()" tunnel="yes"/>
	      </xsl:apply-templates>
	    </div>
	    <div class="versltn">
	      <xsl:apply-templates select="//note[@type='avataranika' and @target=$correspkey]" mode="avataranika">
		<xsl:with-param name="transc" select="false()" tunnel="yes"/>
	      </xsl:apply-templates>
	      
	      <xsl:apply-templates>
		<xsl:with-param name="transc" select="false()" tunnel="yes"/>
	      </xsl:apply-templates>
	    </div>
	    
	  </xsl:element>
	  
	  <div class="translation">
	    <xsl:apply-templates select="document($transl)//note[@type='translation' and @target=$correspkey]"/>
	  </div>
	  <xsl:variable name="philcomm" select="document($transl)//note[@type='philcomm' and @target=$correspkey]"/>
	  <xsl:if test="$philcomm">
	    <details class="philcomm-d">
	      <summary>Philological Commentary</summary>
	      <div class="philcomm">
		<xsl:apply-templates select="$philcomm"/>
	      </div>
	    </details>
	  </xsl:if>
	</div>

	<div class="crit">
	  <div class="apparatus">
	    <h3>Readings</h3>
	    <xsl:for-each select="descendant::note[@type='omission']">
	      <div class="app">
		<xsl:apply-templates/>
	      </div>
	    </xsl:for-each>
	    <xsl:for-each select="//note[@type='avataranika' and @target=$correspkey]/descendant::app">
	      <xsl:call-template name="apparatus"/>
	    </xsl:for-each>
	    <xsl:for-each select="descendant::app">
	      <xsl:call-template name="apparatus"/>
	    </xsl:for-each>
	  </div>
	  <xsl:variable name="marma" select="document($marma)//note[@type='marma' and @target=$correspkey]"/>
	  <xsl:if test="$marma">
	    <details class="marma-d">
	      <summary>More Readings</summary>
	      <div class="marma">
		<xsl:apply-templates select="$marma"/>
	      </div>
	    </details>
	  </xsl:if>

	  <xsl:variable name="sources" select="document($transl)//note[@type='sources' and @target=$correspkey]"/>
	  <xsl:if test="$sources">
	    <details class="sources-d">
	      <summary>Sources</summary>
	      <div class="sources">
		<xsl:apply-templates select="$sources"/>
	      </div>
	    </details>
	  </xsl:if>

	  <xsl:variable name="testimonia" select="document($transl)//note[@type='testimonia' and @target=$correspkey]"/>
	  <xsl:if test="$testimonia">
	    <details class="testimonia-d">
	      <summary>Testimonia</summary>
	      <div class="testimonia">
		<xsl:apply-templates select="$testimonia"/>
	      </div>
	    </details>
	  </xsl:if>
	  
	</div>
      </div>

      <xsl:variable name="jyotsna" select="document($jyotsna)//note[@type='jyotsna' and contains(@target, $correspkey)]"/>
      <xsl:if test="$jyotsna">
	<details class="jyotsna-d">
	  <summary>Jyotsna Commentary
	  <xsl:if test="not($jyotsna[@target=$correspkey])">
	    for verses <xsl:value-of select="replace($jyotsna/@target, '#hp0*(\d+)_0*(\d+).*#hp0*(\d+)_0*(\d+)', '$1.$2-$4')"/>
	  </xsl:if>
	  </summary>
	  <div class="jyotsna">
	    <xsl:apply-templates select="$jyotsna"/>
	  </div>
	</details>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="div[@type='colophon']">
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
	      <xsl:value-of select="replace(@xml:id, 'hp0*(\d+)_.*', 'HP $1 Colophon')"/>
	    </span>
	    <div class="versdev">
	      <xsl:apply-templates>
		<xsl:with-param name="transc" select="true()" tunnel="yes"/>
	      </xsl:apply-templates>
	    </div>
	    
	    <div class="versltn">
	      <xsl:apply-templates>
		<xsl:with-param name="transc" select="true()" tunnel="yes"/>
	      </xsl:apply-templates>
	    </div>
	  </xsl:element>
	</div>

	<div class="crit">
	  <div class="apparatus">
	    <h3>Readings</h3>
	    <xsl:for-each select="descendant::app">
	      <xsl:call-template name="apparatus"/>
	    </xsl:for-each>
	  </div>
	</div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="note" mode="avataranika">
    <p class="avataranika">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- skp and skm, here: deva-ignore and ltn-ignore  -->
  <xsl:template match="seg[@type='deva-ignore']"/>
  
  <xsl:template match="seg[@type='deva-ignore']" mode="lemma">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="lem/text()|rdg/text()" mode="lemma">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="seg[@type='ltn-ignore']">
    <xsl:param name="transc" tunnel="yes"/>

    <xsl:if test="not($transc)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="seg[@type='ltn-ignore']" mode="lemma"/>
  
  <!-- iast2nagari for text nodes of hp and avataranika -->
  <xsl:template match="l[not(ancestor::note)]//text()|note[@type='avataranika']//text()|div[@type='colophon']//text()">
    <xsl:param name="transc" tunnel="yes"/>

    <xsl:variable name="addstring">
      <xsl:value-of select="parent::*/seg[@type='ltn-ignore']"/>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$transc">
	
	<xsl:value-of select="replace(replace(
			      translate(
			      replace(replace(replace(
			      translate(
			      replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(concat($addstring,.),
			      '([kgṅcjñṭḍṇtdnpbmyrlvśṣsh]h?) *','$1्'),
			      '् *ai','ै'),
			      '् *au','ौ'),
			      '् *a','_'),
			      '् *ā','ा'),
			      '् *i','ि'),
			      '् *ī','ी'),
			      '् *u','ु'),
			      '् *ū','ू'),
			      '् *ṛ','ृ'),
			      '् *ṝ','ॄ'),
			      '् *ḷ','ॢ'),
			      '् *ḹ','ॣ'),
			      '् *e','े'),
			      '् *o','ो'),
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
			      'kgṅcjñṭḍṇtdnpbmyrlvśṣsh','कगङचजञटडणतदनपबमयरलवशषसह'),
			      '_',''),
			      'ai','ऐ'),
			      'au','औ'),
			      'aāiīuūṛṝeo','अआइईउऊऋॠएओ'),
			      '//',' ॥'),
			      '/',' ।')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="replace(.,'\s*/(/)?',' /$1')"/>
      </xsl:otherwise>
    </xsl:choose>
    
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
	<xsl:when test="rdg">
	  <xsl:apply-templates select="descendant::rdg[1]" mode="lemma"/>
	  <xsl:text> ]</xsl:text>
	  <xsl:text> </xsl:text>
	  <xsl:for-each select="descendant::rdg[position() > 1][not(position() = last())]">
	    <xsl:apply-templates select="."/><xsl:text>, </xsl:text>
	  </xsl:for-each>
	  <xsl:apply-templates select="descendant::rdg[position() = last()]"/>
	</xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="lem|rdg" mode="lemma">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <span class="lem">
      <xsl:apply-templates mode="lemma"/>
    </span>
    <xsl:call-template name="sigla"/>
  </xsl:template>

  <xsl:template match="lem|rdg">
    <xsl:value-of select="."/>
    <xsl:apply-templates select="descendant::gap"/>
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
	      <xsl:apply-templates select="$tree[@xml:id = $idkey]/abbr"/>
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

  <!-- refs -->
  <xsl:template match="ref">
    <xsl:choose>
      <xsl:when test="@target">
	<xsl:variable name="tree" select="//*"/>
	<xsl:choose>
	  <xsl:when test="starts-with(@target, '#')">
	    <xsl:variable name="idkey" select="substring-after(@target, '#')"/>
	    <xsl:element name="span">
	      <xsl:attribute name="class">siglum</xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="normalize-space($tree[@xml:id = $idkey])"/>
	      </xsl:attribute>
	      <xsl:value-of select="."/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="."/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <!-- tokenize refs without target (omissions) -->
      <xsl:otherwise>
	<xsl:variable name="tree" select="//*"/>
	<xsl:for-each select="tokenize(.,',')">
	  <xsl:variable name="idkey" select="."/>
	   <xsl:element name="span">
	      <xsl:attribute name="class">siglum</xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="normalize-space($tree[@xml:id = $idkey])"/>
	      </xsl:attribute>
	      <xsl:value-of select="."/>
	   </xsl:element>
	   <xsl:if test="position() &lt; last()-1">
	    <xsl:text>, </xsl:text>
	  </xsl:if>
	  <xsl:if test="position()=last()-1">
	    <xsl:text> and </xsl:text>
	  </xsl:if>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- simple html equivalents -->
  <xsl:template match="l[not(ancestor::note)]">
    <p class="hpvers"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="div[@type='colophon']/p">
    <p class="colophon"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="p">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <!-- non-main stanzas -->
  <xsl:template match="lg[ancestor::note]">
    <div class="lg">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="l[ancestor::note]">
    <p class="versinnote"><xsl:apply-templates/></p>
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

  <!-- gaps with reason -->
  <xsl:template match="gap[@reason]">
    <i><xsl:value-of select="@reason"/></i>
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
  <xsl:template match="hi[not(@rend='sub' or @rend='sup' or @rend='grey')]">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <!-- subscript -->
  <xsl:template match="hi[@rend='sub']">
    <sub><xsl:apply-templates/></sub>
  </xsl:template>

  <!-- superscript -->
  <xsl:template match="hi[@rend='sup']">
    <sup><xsl:apply-templates/></sup>
  </xsl:template>

  <!-- grey -->
  <xsl:template match="hi[@rend='grey']">
    <span class="grey"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!--deletions -->
  
</xsl:stylesheet>
