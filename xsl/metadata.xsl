<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    xml:lang="en"
    dc:identifier="metadata"
    dc:title="Extract metadata from a document"
    dc:creator="rv1971@web.de"
    dc:created="2023-04-13"
    dc:modified="2023-04-13">
  <xsd:annotation>
    <xsd:documentation>
      <p>Define a number of metadata parameters and get their default
      values from corresponding attributes or children of
      <code>$a:metaRoot</code>.</p>
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

      <xsl:when test="contains($stylesheet, 'href=&apos;')">
        <xsl:value-of
            select="substring-before(substring-after($stylesheet, 'href=&apos;'), '&apos;')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:param>

  <xsl:param
      name="a:xslBaseUrl"
      rdfs:label="URL of directory containing a:xslUrl">
    <xsl:call-template name="a:basename">
      <xsl:with-param name="path" select="$a:xslUrl"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:param
      name="a:metaRoot"
      select="/*"
      rdfs:label="Element where metadata is taken from"/>

  <xsl:variable
      name="dc:identifier"
      select="$a:metaRoot/@dc:identifier|$a:metaRoot/dc:identifier"/>

  <xsl:variable
      name="dc:title"
      select="$a:metaRoot/@dc:title|$a:metaRoot/dc:title"/>

  <xsl:variable
      name="dc:creator"
      select="$a:metaRoot/@dc:creator|$a:metaRoot/dc:creator"/>

  <xsl:variable
      name="dc:publisher"
      select="$a:metaRoot/@dc:publisher|$a:metaRoot/dc:publisher"/>

  <xsl:variable
      name="dc:created"
      select="$a:metaRoot/@dc:created|$a:metaRoot/dc:created"/>

  <xsl:variable
      name="dc:modified"
      select="$a:metaRoot/@dc:modified|$a:metaRoot/dc:modified"/>

  <xsl:variable
      name="dc:accessRights"
      select="$a:metaRoot/@dc:accessRights|$a:metaRoot/dc:accessRights"/>

  <xsl:variable
      name="dc:rights"
      select="$a:metaRoot/@dc:rights|$a:metaRoot/dc:rights"/>

  <xsl:variable
      name="dc:rightsHolder"
      select="$a:metaRoot/@dc:rightsHolder|$a:metaRoot/dc:rightsHolder"/>

  <xsl:variable
      name="owl:versionInfo"
      select="$a:metaRoot/@owl:versionInfo|$a:metaRoot/owl:versionInfo"/>

  <xsl:template name="a:basename">
    <xsl:param name="path" select="."/>
    <xsl:param name="pos" select="1"/>
    <xsl:param name="tail" select="$path"/>

    <xsl:choose>
      <xsl:when test="contains($tail, '/')">
        <xsl:call-template name="a:basename">
          <xsl:with-param name="path" select="$path"/>
          <xsl:with-param
              name="pos"
              select="$pos + string-length(substring-before($tail, '/')) + 1"/>
          <xsl:with-param name="tail" select="substring-after($tail, '/')"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="substrint($path, $pos)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
