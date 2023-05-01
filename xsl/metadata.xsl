<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    version="1.0"
    xml:lang="en"
    dc:identifier="metadata"
    dc:title="Extract metadata from a document"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2023-04-19">
  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>Define a number of metadata parameters and get their default
      values from corresponding attributes or children of
      <code>$a:metaRoot</code>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="a:xslUrl"
      rdfs:label="URL of XSLT as found in processing instruction">
    <xsl:variable
        name="stylesheet"
        select="/processing-instruction()[local-name(.) = 'xml-stylesheet'][1]"/>

    <xsl:choose>
      <xsl:when test="contains($stylesheet, 'href=&quot;')">
        <xsl:value-of
            select="substring-before(substring-after($stylesheet, 'href=&quot;'), '&quot;')"/>
      </xsl:when>

      <xsl:when test='contains($stylesheet, "href=&apos;")'>
        <xsl:value-of
            select='substring-before(substring-after($stylesheet, "href=&apos;"), "&apos;")'/>
      </xsl:when>
    </xsl:choose>
  </xsl:param>

  <xsl:param
      name="a:xslDirUrl"
      rdfs:label="URL of directory containing a:xslUrl">
    <xsl:call-template name="a:dirname">
      <xsl:with-param name="path" select="$a:xslUrl"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:param
      name="a:metaRoot"
      select="/*"
      rdfs:label="Element where metadata is taken from"/>

  <xsl:param
      name="dc:identifier"
      select="$a:metaRoot/@dc:identifier|$a:metaRoot/dc:identifier"
      rdfs:label="An unambiguous reference to the resource within a given context"/>

  <xsl:param
      name="dc:title"
      select="$a:metaRoot/@dc:title|$a:metaRoot/dc:title"
      rdfs:label="A name given to the resource"/>

  <xsl:param
      name="dc:creator"
      select="$a:metaRoot/@dc:creator|$a:metaRoot/dc:creator"
      rdfs:label="An entity responsible for making the resource"/>

  <xsl:param
      name="dc:publisher"
      select="$a:metaRoot/@dc:publisher|$a:metaRoot/dc:publisher"
      rdfs:label="An entity responsible for making the resource available"/>

  <xsl:param
      name="dc:created"
      select="$a:metaRoot/@dc:created|$a:metaRoot/dc:created"
      rdfs:label="Date of creation of the resource"/>

  <xsl:param
      name="dc:modified"
      select="$a:metaRoot/@dc:modified|$a:metaRoot/dc:modified"
      rdfs:label="Date on which the resource was changed"/>

  <xsl:param
      name="dc:accessRights"
      select="$a:metaRoot/@dc:accessRights|$a:metaRoot/dc:accessRights"
      rdfs:label="Information about who access the resource or an indication of its security status"/>

  <xsl:param
      name="dc:rights"
      select="$a:metaRoot/@dc:rights|$a:metaRoot/dc:rights"
      rdfs:label="Information about rights held in and over the resource"/>

  <xsl:param
      name="dc:rightsHolder"
      select="$a:metaRoot/@dc:rightsHolder|$a:metaRoot/dc:rightsHolder"
      rdfs:label="A person or organization owning or managing rights over the resource"/>

  <xsl:param
      name="owl:versionInfo"
      select="$a:metaRoot/@owl:versionInfo|$a:metaRoot/owl:versionInfo"
      rdfs:label="Version information"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Templates</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:basename"
      match="*|@*"
      mode="a:basename"
      rdfs:label="Get string after last directory separator, complete $path if it does not contain any">
    <xsl:param name="path" select="." rdfs:label="Path to reduce to base name"/>
    <xsl:param name="sep" select="'/'" rdfs:label="Directory separator"/>

    <xsl:choose>
      <xsl:when test="contains($path, $sep)">
        <xsl:call-template name="a:basename">
          <xsl:with-param name="path" select="substring-after($path, $sep)"/>
          <xsl:with-param name="sep" select="$sep"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$path"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      name="a:dirname"
      match="*|@*"
      mode="a:dirname"
      rdfs:label="Get string up to and including last directory separator, empty string if $path does not contain any">
    <xsl:param name="path" select="." rdfs:label="Path to reduce to base name"/>
    <xsl:param name="sep" select="'/'" rdfs:label="Directory separator"/>

    <xsl:if test="contains($path, $sep)">
      <xsl:variable name="basename">
        <xsl:call-template name="a:basename">
          <xsl:with-param name="path" select="$path"/>
          <xsl:with-param name="sep" select="$sep"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of
          select="substring($path, 1, string-length($path) - string-length($basename))"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
