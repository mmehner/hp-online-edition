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
  <xsl:template match="note[@type='omission']"/>
  <xsl:template match="note[@type='foliolost']"/>
  <xsl:template match="note[@type='memo']"/>

  <!-- container for altrecension -->
  <xsl:template match="*[@type='altrec']">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="class">altrec</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <!-- main template -->
  <xsl:template match="lg[not(ancestor::note)]">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <div class="main-wrapper main">
      <div class="vers-trans-com text">
	<div class="vers-wrap hp">
	  <xsl:element name="div">
	    <xsl:attribute name="id">
	      <xsl:value-of select="@xml:id"/>
	    </xsl:attribute>
	    <xsl:attribute name="class">vers-title</xsl:attribute>
	    
	    <span class="number">
	      <xsl:choose>
		<xsl:when test="matches(@xml:id, 'hp\d+_\d+_\d+')">
		  <xsl:value-of select="replace(@xml:id, 'hp0*(\d+)_0*(\d+)_0*(\d+)', 'HP $1.$2*$3')"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="replace(@xml:id, 'hp0*(\d+)_0*(\d+)', 'HP $1.$2')"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </span>
	  </xsl:element>
	  <div class="vers-dev">
	    <xsl:apply-templates>
	      <xsl:with-param name="transc" select="true()" tunnel="yes"/>
	    </xsl:apply-templates>
	  </div>
	  <div class="vers-latin">
	    <xsl:apply-templates>
	      <xsl:with-param name="transc" select="false()" tunnel="yes"/>
	    </xsl:apply-templates>
	  </div>
	  
	  <div class="vers-translation">
	    <xsl:apply-templates select="document($transl)//note[@type='translation' and @target=$correspkey]"/>
	  </div>
	</div>
	
	<xsl:variable name="philcomm" select="document($transl)//note[@type='philcomm' and @target=$correspkey]"/>
	<xsl:if test="$philcomm">
	  <details class="philcomm-d">
	    <summary>Philological Commentary</summary>
	    <div class="philcomm">
	      <p><xsl:apply-templates select="$philcomm"/></p>
	    </div>
	  </details>
	</xsl:if>

	<xsl:variable name="jyotsna" select="document($jyotsna)//note[@type='jyotsna' and contains(@target, $correspkey)]"/>
	<xsl:if test="$jyotsna">
	  <details class="jyotsna-d">
	    <summary>Jyotsna Commentary</summary>
	    <div class="jyotsna">
	      <div class="jyotsnadev">
		<xsl:apply-templates select="$jyotsna"> 
		  <xsl:with-param name="transc" select="true()" tunnel="yes"/>
		</xsl:apply-templates>
	      </div>
	      <div class="jyotsnaltn">
		<xsl:apply-templates  select="$jyotsna">
		  <xsl:with-param name="transc" select="false()" tunnel="yes"/>
		</xsl:apply-templates>
	      </div>
	    </div>
	  </details>
	</xsl:if>
      </div>
      
      <div class="text-apparatus">
	<div class="crit">
	  <xsl:variable name="metre" select="document($transl)//note[@type='metre' and @target=$correspkey]"/>
	  <xsl:if test="$metre">
	    <div class="metre">
	      Metre: <xsl:value-of select="$metre"/>
	    </div>
	  </xsl:if>
	  <details>
	    <summary>Readings</summary>
	    <p class="versinnote">
	      <xsl:for-each select="descendant::note[@type='omission' or @type='foliolost']">
		<div class="app">
		  <xsl:apply-templates/>
		</div>
	      </xsl:for-each>
	      <xsl:for-each select="descendant::app">
		<xsl:call-template name="apparatus"/>
	      </xsl:for-each>
	    </p>
	  </details>
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
    </div>
  </xsl:template>

  <xsl:template match="div[@type='avataranika' or @type='postmula']">
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    <xsl:element name="div">
      <xsl:attribute name="class">main<xsl:if test="not(ancestor::div[@type='altrec']) and not(child::*[not(@type='altrec')])"> altrec</xsl:if>
      </xsl:attribute>
      <div class="hpmeta">
	<div class="text">
	  <xsl:element name="div">
	    <xsl:attribute name="id">
	      <xsl:value-of select="@xml:id"/>
	    </xsl:attribute>
	    <xsl:attribute name="class">hp</xsl:attribute>
	    <div class="versdev">
	      <p class="hpprose">
		<xsl:apply-templates>
		  <xsl:with-param name="transc" select="true()" tunnel="yes"/>
		</xsl:apply-templates>
	      </p>
	    </div>
	    <div class="versltn">
	      <p class="hpprose">
		<xsl:apply-templates>
		  <xsl:with-param name="transc" select="false()" tunnel="yes"/>
		</xsl:apply-templates>
	      </p>
	    </div>
	  </xsl:element>

	  <xsl:variable name="translation" select="document($transl)//note[@type='translation' and @target=$correspkey]"/>
	  <xsl:if test="$translation">
	    <div class="translation-prose">
	      <p class="hpprose">
		<xsl:apply-templates select="$translation"/>
	      </p>
	    </div>
	  </xsl:if>
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

	<xsl:variable name="marma" select="document($marma)//note[@type='marma' and @target=$correspkey]"/>
	<xsl:variable name="sources" select="document($transl)//note[@type='sources' and @target=$correspkey]"/>
	<xsl:variable name="testimonia" select="document($transl)//note[@type='testimonia' and @target=$correspkey]"/>
	<div class="crit">
	  <div class="apparatus">
	    <xsl:choose>
	      <xsl:when test="descendant::app">
		<h3>Readings</h3>
		<xsl:for-each select="descendant::note[@type='omission' or @type='foliolost']">
		  <div class="app">
		    <xsl:apply-templates/>
		  </div>
		</xsl:for-each>
		<xsl:for-each select="descendant::app">
		  <xsl:call-template name="apparatus"/>
		</xsl:for-each>
	      </xsl:when>
	      <xsl:otherwise>
		<h3>No Readings</h3>
	      </xsl:otherwise>
	    </xsl:choose>
	  </div>
	  <xsl:if test="$marma">
	    <details class="marma-d">
	      <summary>More Readings</summary>
	      <div class="marma">
		<xsl:apply-templates select="$marma"/>
	      </div>
	    </details>
	  </xsl:if>

	  <xsl:if test="$sources">
	    <details class="sources-d">
	      <summary>Sources</summary>
	      <div class="sources">
		<xsl:apply-templates select="$sources"/>
	      </div>
	    </details>
	  </xsl:if>
	  
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
    </xsl:element>
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
	    <div class="vers-dev">
	      <p class="hpprose">
	      <xsl:apply-templates>
		<xsl:with-param name="transc" select="true()" tunnel="yes"/>
	      </xsl:apply-templates>
	      </p>
	    </div>
	    
	    <div class="vers-latin">
	      <p class="hpprose">
	      <xsl:apply-templates>
		<xsl:with-param name="transc" select="false()" tunnel="yes"/>
	      </xsl:apply-templates>
	      </p>
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


  <!-- skp and skm, here: deva-ignore and ltn-ignore  -->
  <xsl:template match="seg[@type='deva-ignore']"/>
  
  <xsl:template match="seg[@type='deva-ignore']" mode="lemma">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="app/lem/text()|app/rdg[1]/text()" mode="lemma">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="seg[@type='ltn-ignore']">
    <xsl:param name="transc" tunnel="yes"/>

    <xsl:if test="not($transc)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="seg[@type='ltn-ignore']" mode="lemma"/>
  
  <!-- iast2nagari for text nodes of hp, avataranika, postmula, colophon and jyotsna -->
  <xsl:template match="l[not(ancestor::note)]//text()|div[@type='avataranika' or @type='postmula']//text()|div[@type='colophon']//text()|note[@type='jyotsna']//text()">
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
    <xsl:element name="div">
      <xsl:attribute name="class">app<xsl:if test="ancestor::*[@type='altrec']"> altrec</xsl:if></xsl:attribute>
      <xsl:choose>
	<xsl:when test="lem">
	  <xsl:apply-templates select="lem" mode="lemma"/>
	  <xsl:if test="lem//text()">
	    <xsl:text> ] </xsl:text>
	  </xsl:if>
	  <xsl:for-each select="child::rdg[not(position() = last())]">
	    <xsl:apply-templates select="."/><xsl:text>, </xsl:text>
	  </xsl:for-each>
	  <xsl:apply-templates select="child::rdg[position() = last()]"/>
	</xsl:when>
	<xsl:when test="rdg">
	  <xsl:apply-templates select="child::rdg[1]" mode="lemma"/>
	  <xsl:if test="rdg[1]//text()">
	    <xsl:text> ] </xsl:text>
	  </xsl:if>
	  <xsl:for-each select="child::rdg[position() > 1][not(position() = last())]">
	    <xsl:apply-templates select="."/><xsl:text>, </xsl:text>
	  </xsl:for-each>
	  <xsl:apply-templates select="child::rdg[position() = last()]"/>
	</xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="lem|rdg" mode="lemma">
    <span class="lem">
      <xsl:apply-templates mode="lemma" select="./node()"/>
    </span>
    <xsl:call-template name="sigla"/>
  </xsl:template>

  <xsl:template match="lem|rdg">
    <xsl:value-of select="."/>
    <xsl:apply-templates select="descendant::gap"/>
    <xsl:call-template name="sigla"/>
  </xsl:template>

  <xsl:template name="sigla">
    <xsl:choose>
      <xsl:when test="@wit">
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
      </xsl:when>
      <!-- emendations -->
      <xsl:when test="@resp='ego'">
	<xsl:element name="span">
	  <xsl:attribute name="class">siglum</xsl:attribute>
	  <xsl:attribute name="title">
	    <xsl:text>emendation</xsl:text>
	  </xsl:attribute>
	  <xsl:text> (em.)</xsl:text>
	</xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- refs -->
  <xsl:template match="note[@type='inlineref']">
    <xsl:element name="span">
      <xsl:attribute name="class">inlineref</xsl:attribute>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>)</xsl:text>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="ref">
    <xsl:choose>
      <xsl:when test="@target">
	<xsl:variable name="tree" select="//*"/>
	<xsl:choose>
	  <!-- tokenize @target in refs with local target -->
	  <xsl:when test="starts-with(@target, '#')">
	    <xsl:for-each select="tokenize(substring-after(@target, '#'),',')">
	      <xsl:variable name="idkey" select="."/>
	      <xsl:element name="span">
		<xsl:attribute name="class">siglum</xsl:attribute>
		<xsl:attribute name="title">
		  <xsl:value-of select="normalize-space($tree[@xml:id = $idkey])"/>
		</xsl:attribute>
		<xsl:apply-templates select="$tree[@xml:id = $idkey]/abbr"/>
	      </xsl:element>
	      <xsl:if test="position() &lt; last()-1">
		<xsl:text>, </xsl:text>
	      </xsl:if>
	      <xsl:if test="position()=last()-1">
		<xsl:text> and </xsl:text>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:when>
	  <!-- refs with non-local target (aka links) -->
	  <xsl:otherwise>
	    <xsl:element  name="a">
	      <xsl:attribute name="href">
		<xsl:value-of select="@target"/>
	      </xsl:attribute>
	      <xsl:value-of select="."/>
	    </xsl:element>
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
	    <xsl:apply-templates select="$tree[@xml:id = $idkey]/abbr"/>
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
    <xsl:element name="p">
      <xsl:attribute name="class">vers-line<xsl:if test="not(ancestor::div[@type='altrec']) and not(child::*[not(@type='altrec')])"> altrec</xsl:if>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="div[@type='colophon']/p">
    <p class="colophon"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="q">
    <div class="quote">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="lb">
    <br/>
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

  <xsl:template match="note[@type='appinnote']">
    <span class="appinnote"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- footnotes -->
  <xsl:template match="note[@place='bottom' or @type='myfn']">
    <xsl:element name="span">
      <xsl:attribute name="class">fn</xsl:attribute>
      <xsl:attribute name="title">
	<xsl:apply-templates>
	  <xsl:with-param name="transc" select="false()" tunnel="yes"/>
	</xsl:apply-templates>
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
  
  <!--deletions -->
  
</xsl:stylesheet>
