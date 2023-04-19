<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    version="1.0"
    exclude-result-prefixes="a rdfs xsd"
    xml:lang="en"
    dc:identifier="html-output"
    dc:title="Basic definitions to create HTML output"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2023-04-19">
  <xsl:import href="metadata.xsl"/>
  <xsl:import href="text.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Output method</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:output
      method="xml"
      encoding="UTF-8"
      indent="yes"
      media-type="application/xhtml+xml"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="a:cssList"
      rdfs:label="Whitespace-separated list of CSS files to link to"/>

  <xsl:param
      name="a:jsList"
      rdfs:label="Whitespace-separated list of JS files to link to"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>&lt;head&gt; element</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:resourceUrl"
      rdfs:label="create URL for a resource">
    <xsl:param name="item" rdfs:label="URL"/>
    <xsl:param name="type" rdfs:label="css|js|icon"/>

    <xsl:value-of select="$item"/>
  </xsl:template>

  <xsl:template name="a:cssLinks" rdfs:label="Create CSS &lt;link>s">
    <xsl:param
        name="cssList"
        select="normalize-space($a:cssList)"
        rdfs:label="Whitespace-separated list of CSS files to link to"/>

    <xsl:if test="$cssList != ''">
      <xsl:variable
          name="item"
          select="substring-before(concat($cssList, ' '), ' ')"/>

      <link rel="stylesheet" type="text/css">
        <xsl:attribute name="href">
          <xsl:call-template name="a:resourceUrl">
            <xsl:with-param name="item" select="$item"/>
            <xsl:with-param name="type" select="'css'"/>
          </xsl:call-template>
        </xsl:attribute>
      </link>

      <xsl:if test="substring-after($cssList, ' ')">
        <xsl:call-template name="a:cssLinks">
          <xsl:with-param
              name="cssList"
              select="substring-after($cssList, ' ')"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="a:jsLinks" rdfs:label="Create JS &lt;script>s">
    <xsl:param
        name="jsList"
        select="normalize-space($a:jsList)"
        rdfs:label="Whitespace-separated list of JS files to link to"/>

    <xsl:if test="$jsList != ''">
      <xsl:variable
          name="item"
          select="substring-before(concat($jsList, ' '), ' ')"/>

      <script type="text/javascript">
        <xsl:attribute name="src">
          <xsl:call-template name="a:resourceUrl">
            <xsl:with-param name="item" select="$item"/>
            <xsl:with-param name="type" select="'js'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:text> </xsl:text>
      </script>

      <xsl:if test="substring-after($jsList, ' ')">
        <xsl:call-template name="a:jsLinks">
          <xsl:with-param name="jsList" select="substring-after($jsList, ' ')"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="a:faviconLink" rdfs:label="create favicon &lt;link>"/>

  <xsl:template
      name="a:extraHeadContent"
      rdfs:label="Create extra content to include in &lt;head&gt; element"/>

  <xsl:template
      xmlns:owl="http://www.w3.org/2002/07/owl#"
      name="a:head"
      rdfs:label="Create &lt;head&gt; element">
    <head>
      <meta charset="utf-8"/>

      <xsl:if test="$dc:identifier">
        <meta property="dc:identifier" content="{$dc:identifier}"/>
      </xsl:if>

      <title property="dc:title">
        <xsl:value-of select="$dc:title"/>
      </title>

      <xsl:if test="$dc:creator">
        <meta property="dc:creator" name="author" content="{$dc:creator}"/>
      </xsl:if>

      <xsl:if test="$dc:created">
        <meta property="dc:created" content="{$dc:created}"/>
      </xsl:if>

      <xsl:if test="$dc:modified">
        <meta property="dc:modified" content="{$dc:modified}"/>
      </xsl:if>

      <xsl:if test="$dc:accessRights">
        <meta property="dc:accessRights" content="{$dc:accessRights}"/>
      </xsl:if>

      <xsl:if test="$dc:rights">
        <meta property="dc:rights" content="{$dc:rights}"/>
      </xsl:if>

      <xsl:if test="$owl:versionInfo">
        <meta property="owl:versionInfo" content="{$owl:versionInfo}"/>
      </xsl:if>

      <xsl:call-template name="a:cssLinks"/>

      <xsl:call-template name="a:jsLinks"/>

      <xsl:call-template name="a:faviconLink"/>

      <xsl:call-template name="a:extraHeadContent"/>
    </head>
  </xsl:template>
</xsl:stylesheet>
