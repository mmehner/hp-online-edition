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
  <!-- <xsl:param name="marma"/> -->
  <xsl:param name="jyotsna"/>

  <xsl:variable name="groupsDoc" select="document('../xml/groups.xml')"/>
  <xsl:key name="group-by-id" match="Q{}group" use="Q{}id"/>
  
  
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
    <xsl:param name="x4-rec" tunnel="yes"/>
    <xsl:element name="{local-name()}">
      <xsl:if test="not($x4-rec)">
	<xsl:attribute name="class">altrec</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- main switch -->
  <xsl:template match="lg[not(ancestor::note)]">
    <xsl:variable name="tree" select="//*"/>
    <xsl:variable name="lggroup" select="key('group-by-id', @xml:id, $groupsDoc)"/>
    <xsl:choose>
      <!-- first in group -->
      <xsl:when test="@xml:id = $lggroup/Q{}id[1]">
	<!-- <xsl:message select="'Current ID:', string(@xml:id)"/> -->
	<div class="main">
	  <div class="hpmeta">
	    <div class="text">
	      <xsl:element name="div">
		<xsl:attribute name="id">
		  <xsl:value-of select="@xml:id"/>
		</xsl:attribute>
		<xsl:attribute name="class">hp</xsl:attribute>
		<span class="number">
		  HP <xsl:call-template name="id-to-number"/>
		  <xsl:text>–</xsl:text>
		  <xsl:choose>
		    <xsl:when test="matches($lggroup/Q{}id[position() = last()], 'hp\d+_\d+_\d+')">
		      <xsl:value-of select="replace($lggroup/Q{}id[position() = last()], 'hp0*(\d+)_0*(\d+)_0*(\d+)', '$2*$3')"/>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:value-of select="replace($lggroup/Q{}id[position() = last()], 'hp0*(\d+)_0*(\d+)', '$2')"/>
		    </xsl:otherwise>
		  </xsl:choose>
		</span>
		<xsl:for-each select="$tree[@xml:id = $lggroup/Q{}id]">
		  <xsl:call-template name="mainvers-dev-and-ltn"/>
		</xsl:for-each>
	      </xsl:element>
	      
	      <div class="translation">
		<xsl:for-each select="$tree[@xml:id = $lggroup/Q{}id]">
		  <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
		  <xsl:apply-templates select="document($transl)//note[@type='translation' and @target=$correspkey]"/>
		</xsl:for-each>
	      </div>

	      <details class="philcomm-d">
		<summary>Philological Commentary</summary>
		<div class="philcomm">
		  <xsl:for-each select="$tree[@xml:id = $lggroup/Q{}id]">
		    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
		    <xsl:variable name="philcomm" select="document($transl)//note[@type='philcomm' and @target=$correspkey]"/>
		    <xsl:apply-templates select="$philcomm"/>
		  </xsl:for-each>
		</div>
	      </details>
	    </div>

	    <div class="crit">
	      <xsl:for-each select="$tree[@xml:id = $lggroup/Q{}id]">
		<xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
		<xsl:variable name="metre" select="document($transl)//note[@type='metre' and @target=$correspkey]"/>
		<xsl:if test="$metre">
		  <div class="metre">
		    Metre <xsl:call-template name="id-to-number"/>: <xsl:value-of select="$metre"/>
		  </div>
		</xsl:if>
		<div class="apparatus">
		  <h3>Readings <xsl:call-template name="id-to-number"/></h3>
		  <xsl:for-each select="descendant::note[@type='omission' or @type='foliolost']">
		    <div class="app">
		      <xsl:apply-templates/>
		    </div>
		  </xsl:for-each>
		  <xsl:for-each select="descendant::app">
		    <xsl:call-template name="apparatus"/>
		  </xsl:for-each>
		</div>

		<xsl:variable name="sources" select="document($transl)//note[@type='sources' and @target=$correspkey]"/>
		<xsl:if test="$sources">
		  <details class="sources-d">
		    <summary>Sources</summary>
		    <div class="sources">
		      <xsl:apply-templates select="$sources"/>
		    </div>
		  </details>
		</xsl:if>
	      </xsl:for-each>

	      <details class="testimonia-d">
		<summary>Testimonia</summary>
		<div class="testimonia">
		  <xsl:for-each select="$tree[@xml:id = $lggroup/Q{}id]">
		    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
		    <xsl:variable name="testimonia" select="document($transl)//note[@type='testimonia' and @target=$correspkey]"/>
		    <xsl:apply-templates select="$testimonia"/>
		  </xsl:for-each>
		</div>
	      </details>
	    </div>
	  </div>

	  <details class="jyotsna-d">
	    <summary>Jyotsna Commentary</summary>
	    <div class="jyotsna">
	      <xsl:for-each select="$tree[@xml:id = $lggroup/Q{}id]">
		<xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
		<xsl:variable name="jyotsna" select="document($jyotsna)//note[@type='jyotsna' and contains(@target, $correspkey)]"/>
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
	      </xsl:for-each>
	    </div>
	  </details>
	</div>
      </xsl:when>
      <!-- skip further group items -->
      <xsl:when test="$lggroup"/>
      <xsl:otherwise>
	<xsl:call-template name="singleverse"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- main template for single verses-->
  <xsl:template name="singleverse">
    <xsl:param name="x4-rec" tunnel="yes"/>
    <xsl:param name="textonly" tunnel="yes"/>
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    
    <div class="main">
      <div class="hpmeta">
	<div class="text">

	  <xsl:element name="div">
	    <xsl:attribute name="id">
	      <xsl:choose>
		<xsl:when test="$x4-rec">
		  <xsl:text>hpx4.</xsl:text>
		  <xsl:value-of select="$x4-rec"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="@xml:id"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:attribute>
	    <xsl:attribute name="class">hp</xsl:attribute>
	    <span class="number">
	      HP
	      <xsl:choose>
		<xsl:when test="$x4-rec">
		  X4.<xsl:value-of select="$x4-rec"/> (= <xsl:call-template name="id-to-number"/>)
		</xsl:when>
		<xsl:otherwise>
		  <xsl:call-template name="id-to-number"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </span>
	    <xsl:call-template name="mainvers-dev-and-ltn"/>
	  </xsl:element>

	  <xsl:if test="not($textonly)">
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
	  </xsl:if>
	</div>

	<div class="crit">
	  <xsl:variable name="metre" select="document($transl)//note[@type='metre' and @target=$correspkey]"/>
	  <xsl:if test="$metre">
	    <div class="metre">
	      Metre: <xsl:value-of select="$metre"/>
	    </div>
	  </xsl:if>
	  <div class="apparatus">
	    <h3>Readings</h3>
	    <xsl:for-each select="descendant::note[@type='omission' or @type='foliolost']">
	      <div class="app">
		<xsl:apply-templates/>
	      </div>
	    </xsl:for-each>
	    <xsl:for-each select="descendant::app">
	      <xsl:call-template name="apparatus"/>
	    </xsl:for-each>
	  </div>
	  <!-- <xsl:variable name="marma" select="document($marma)//note[@type='marma' and @target=$correspkey]"/> -->
	  <!-- <xsl:if test="$marma"> -->
	  <!--   <details class="marma-d"> -->
	  <!--     <summary>More Readings</summary> -->
	  <!--     <div class="marma"> -->
	  <!-- 	<xsl:apply-templates select="$marma"/> -->
	  <!--     </div> -->
	  <!--   </details> -->
	  <!-- </xsl:if> -->

	  <xsl:if test="not($textonly)">
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
	  </xsl:if>
	  
	</div>
      </div>

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
  </xsl:template>

  <xsl:template name="id-to-number">
    <xsl:choose>
      <xsl:when test="matches(@xml:id, 'hp\d+_\d+_\d+')">
	<xsl:value-of select="replace(@xml:id, 'hp0*(\d+)_0*(\d+)_0*(\d+)', '$1.$2*$3')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="replace(@xml:id, 'hp0*(\d+)_0*(\d+)', '$1.$2')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mainvers-dev-and-ltn">
    <div class="versdev">
      <xsl:apply-templates>
	<xsl:with-param name="transc" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
    </div>
    <div class="versltn">
      <xsl:apply-templates>
	<xsl:with-param name="transc" select="false()" tunnel="yes"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="div[@type='avataranika' or @type='postmula']">
    <xsl:param name="x4-rec" tunnel="yes"/>
    <xsl:param name="textonly" tunnel="yes"/>
    <xsl:variable name="correspkey" select="concat('#', @xml:id )"/>
    
    <xsl:element name="div">
      <xsl:attribute name="class">main<xsl:if test="not(ancestor::div[@type='altrec']) and not(child::*[not(@type='altrec')]) and not($x4-rec)"> altrec</xsl:if>
      </xsl:attribute>
      <div class="hpmeta">
	<div class="text">
	  <xsl:element name="div">
	    <xsl:attribute name="id">
	      <xsl:if test="$x4-rec">x</xsl:if>
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

	  <xsl:if test="not($textonly)">
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
	  </xsl:if>
	</div>

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
	  
	  <xsl:if test="not($textonly)">
	    <!-- <xsl:variable name="marma" select="document($marma)//note[@type='marma' and @target=$correspkey]"/> -->
	    <xsl:variable name="sources" select="document($transl)//note[@type='sources' and @target=$correspkey]"/>
	    <xsl:variable name="testimonia" select="document($transl)//note[@type='testimonia' and @target=$correspkey]"/>
	    <!-- <xsl:if test="$marma"> -->
	    <!--   <details class="marma-d"> -->
	    <!--     <summary>More Readings</summary> -->
	    <!--     <div class="marma"> -->
	    <!-- 	<xsl:apply-templates select="$marma"/> -->
	    <!--     </div> -->
	    <!--   </details> -->
	    <!-- </xsl:if> -->
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
  <xsl:template match="seg[@type='deva-ignore']" mode="lemma">
    <xsl:value-of select="."/>
  </xsl:template>  

  <xsl:template match="seg[@type='deva-ignore']"/>  

  <xsl:template match="app/lem/text()|app/rdg[1]/text()" mode="lemma">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="seg[@type='ltn-ignore']" mode="lemma"/>
  
  <xsl:template match="seg[@type='ltn-ignore']">
    <xsl:param name="transc" tunnel="yes"/>

    <xsl:if test="not($transc)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>
  
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
    <xsl:param name="x4-rec" tunnel="yes"/>
    <xsl:element name="div">
      <xsl:attribute name="class">app<xsl:if test="ancestor::*[@type='altrec'] and not($x4-rec)"> altrec</xsl:if></xsl:attribute>
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
	<xsl:text> </xsl:text>
	<xsl:variable name="tree" select="//*"/>
	<xsl:for-each select="tokenize(@wit,'\s+')">
	  <xsl:variable name="token" select="."/>
	  <xsl:if test="position()>=2">
	    <!-- <xsl:text> (</xsl:text> -->
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
	<!-- <xsl:text>)</xsl:text> -->
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

  
  <!-- refs specific to 4X -->
  <xsl:template match="ref[@type='set']">
    <xsl:variable name="idkey" select="substring-after(@target, '#')"/>
    <xsl:variable name="textsource" select="document('../xml/HP4_pub-tei.xml')"/>
    <xsl:apply-templates select="$textsource//lg[@xml:id = $idkey]">
      <xsl:with-param name="x4-rec" select="@n" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ref[@type='textonly']">
    <xsl:variable name="idkey" select="substring-after(@target, '#')"/>
    <xsl:variable name="textsource" select="document('../xml/HP4_pub-tei.xml')"/>
    <xsl:apply-templates select="$textsource//lg[@xml:id = $idkey]">
      <xsl:with-param name="x4-rec" select="@n" tunnel="yes"/>
      <xsl:with-param name="textonly" select="true()" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ref[@type='avaset']">
    <xsl:variable name="idkey" select="substring-after(@target, '#')"/>
    <xsl:variable name="textsource" select="document('../xml/HP4_pub-tei.xml')"/>
    <xsl:apply-templates select="$textsource//div[@xml:id = $idkey]">
      <xsl:with-param name="x4-rec" select="true()" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="ref[@type='avatextonly']">
    <xsl:variable name="idkey" select="substring-after(@target, '#')"/>
    <xsl:variable name="textsource" select="document('../xml/HP4_pub-tei.xml')"/>
    <xsl:apply-templates select="$textsource//div[@xml:id = $idkey]">
      <xsl:with-param name="x4-rec" select="true()" tunnel="yes"/>
      <xsl:with-param name="textonly" select="true()" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  


  <!-- other refs -->
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
    <xsl:param name="x4-rec" tunnel="yes"/>
    <xsl:element name="p">
      <xsl:attribute name="class">hpvers<xsl:if test="not(ancestor::div[@type='altrec']) and not(child::*[not(@type='altrec')]) and not($x4-rec)"> altrec</xsl:if>
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
  <xsl:template match="list[@rend='numbered']">
    <ol class="list">
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  
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
  
  <!--pass-through -->
  <xsl:template match="ab|s">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--deletions -->
  
</xsl:stylesheet>
