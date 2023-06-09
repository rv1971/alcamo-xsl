<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    version="1.0"
    exclude-result-prefixes="a dc owl rdfs xsd"
    xml:lang="en"
    dc:identifier="html-document.alone"
    dc:title="HTML document creation"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2023-06-02">
  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>Templates to generate an HTML document with a
      <code>&lt;head&gt;</code> element and some structure in the
      <code>&lt;body&gt;</code> element.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Namespace aliases</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:namespace-alias
      xmlns:dc-alias="tag:rv1971@web.de,2021:alcamo-xsl:alias:dc#"
      stylesheet-prefix="dc-alias"
      result-prefix="dc"/>

  <xsl:namespace-alias
      xmlns:owl-alias="tag:rv1971@web.de,2021:alcamo-xsl:alias:owl#"
      stylesheet-prefix="owl-alias"
      result-prefix="owl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Output method</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:output
      method="xml"
      encoding="UTF-8"
      media-type="application/xhtml+xml"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>&lt;head&gt; element</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="a:cssLinks" rdfs:label="Create CSS &lt;link>s">
    <xsl:param
        name="cssList"
        select="normalize-space($a:cssList)"
        rdfs:label="Whitespace-separated list of CSS files to link to"/>

    <xsl:if test="$cssList">
      <xsl:variable
          name="item"
          select="substring-before(concat($cssList, ' '), ' ')"/>

      <link rel="stylesheet" type="text/css" href="{$item}"/>

      <xsl:if test="substring-after($cssList, ' ')">
        <xsl:apply-templates select="." mode="a:cssLinks">
          <xsl:with-param
              name="cssList"
              select="substring-after($cssList, ' ')"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="a:jsLinks" rdfs:label="Create JS &lt;script>s">
    <xsl:param
        name="jsList"
        select="normalize-space($a:jsList)"
        rdfs:label="Whitespace-separated list of JS files to link to"/>

    <xsl:if test="$jsList">
      <xsl:variable
          name="item"
          select="substring-before(concat($jsList, ' '), ' ')"/>

      <script type="text/javascript" src="{$item}">
        <xsl:text> </xsl:text>
      </script>

      <xsl:if test="substring-after($jsList, ' ')">
        <xsl:apply-templates select="." mode="a:jsLinks">
          <xsl:with-param name="jsList" select="substring-after($jsList, ' ')"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template
      match="*"
      mode="a:faviconLink"
      rdfs:label="Create favicon &lt;link>"/>

  <xsl:template
      match="*"
      mode="a:extraHeadContent"
      rdfs:label="Create extra content to include in &lt;head&gt; element"/>

  <xsl:template
      xmlns:dc="tag:rv1971@web.de,2021:alcamo-xsl:alias:dc#"
      xmlns:dc_="http://purl.org/dc/terms/"
      xmlns:owl="tag:rv1971@web.de,2021:alcamo-xsl:alias:owl#"
      xmlns:owl_="http://www.w3.org/2002/07/owl#"
      match="*"
      mode="a:head"
      rdfs:label="Create &lt;head&gt; element">
    <head>
      <meta charset="utf-8"/>

      <xsl:if test="$dc_:identifier">
        <meta property="dc:identifier" content="{$dc_:identifier}"/>
      </xsl:if>

      <title property="dc:title">
        <xsl:value-of select="$dc_:title"/>
      </title>

      <xsl:if test="$dc_:creator">
        <meta property="dc:creator" name="author" content="{$dc_:creator}"/>
      </xsl:if>

      <xsl:if test="$dc_:created">
        <meta property="dc:created" content="{$dc_:created}"/>
      </xsl:if>

      <xsl:if test="$dc_:modified">
        <meta property="dc:modified" content="{$dc_:modified}"/>
      </xsl:if>

      <xsl:if test="$dc_:accessRights">
        <meta property="dc:accessRights" content="{$dc_:accessRights}"/>
      </xsl:if>

      <xsl:if test="$dc_:rights">
        <meta property="dc:rights" content="{$dc_:rights}"/>
      </xsl:if>

      <xsl:if test="$owl_:versionInfo">
        <meta property="owl:versionInfo" content="{$owl_:versionInfo}"/>
      </xsl:if>

      <xsl:apply-templates select="." mode="a:cssLinks"/>

      <xsl:apply-templates select="." mode="a:jsLinks"/>

      <xsl:apply-templates select="." mode="a:faviconLink"/>

      <xsl:apply-templates select="." mode="a:extraHeadContent"/>
    </head>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Error reporting</h2>

      <p>The template with mode <code>a:collect-errors</code> applied
      to the document root is expected to create either an empty
      result or an HTML tree fragment to be inserted into the
      output. Implementation as a mode rather than a named template
      allows to apply an imported version of it.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="*"
      mode="a:collect-errors"
      rdfs:label="To be overriden in importing stylesheets"/>

  <xsl:template
      match="*"
      mode="a:report-errors"
      rdfs:label="If instantiation of a:collect-errors is nonempty, add it to the result tree and/or output it as a message">
    <xsl:variable name="errors">
      <xsl:apply-templates select="." mode="a:collect-errors"/>
    </xsl:variable>

    <xsl:if test="$errors != ''">
      <xsl:if
          test="$a:errorReportingChannels = 'output' or $a:errorReportingChannels = 'both'">
        <div class="error">
          <xsl:copy-of select="$errors"/>
        </div>
      </xsl:if>

      <xsl:if
          test="$a:errorReportingChannels = 'message' or $a:errorReportingChannels = 'both'">
        <xsl:message>
          <xsl:copy-of select="$errors"/>
        </xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Page skeleton</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="*"
      mode="a:toc"
      rdfs:label="Create table of contents, to be defined in importing stylesheets"/>

  <xsl:template
      match="*"
      mode="a:page-header"
      rdfs:label="Create &lt;header&gt; element for page">
    <header>
      <h1>
        <xsl:value-of select="$dc:title"/>
      </h1>

      <p>
        <xsl:if test="$owl:versionInfo">
          <xsl:text>Version </xsl:text>
          <xsl:apply-templates select="$owl:versionInfo" mode="a:auto"/>
          <xsl:text>, </xsl:text>
        </xsl:if>

        <xsl:if test="$dc:creator">
          <xsl:apply-templates select="$dc:creator" mode="a:agent"/>
          <xsl:text>, </xsl:text>
        </xsl:if>

        <xsl:call-template name="a:created-modified"/>
      </p>

      <xsl:apply-templates select="." mode="a:toc"/>
    </header>
  </xsl:template>

  <xsl:template
      match="*"
      mode="a:page-main"
      rdfs:label="Create main part of page, to be defined in importing stylesheets"/>

  <xsl:template
      match="*"
      mode="a:page-footer"
      rdfs:label="Create &lt;footer&gt; element for page, to be defined in importing stylesheets"/>

  <xsl:template match="/" rdfs:label="Create the document">
    <xsl:choose>
      <xsl:when test="$a:errorsOnly">
        <xsl:apply-templates mode="a:report-errors"/>
      </xsl:when>

      <xsl:otherwise>
        <html>
          <xsl:for-each select="$a:metaRoot/@xml:lang">
            <xsl:copy/>
          </xsl:for-each>

          <xsl:apply-templates mode="a:head"/>

          <body>
            <xsl:apply-templates mode="a:page-header"/>

            <xsl:apply-templates mode="a:report-errors"/>

            <xsl:apply-templates mode="a:page-main"/>

            <xsl:apply-templates mode="a:page-footer"/>
          </body>
        </html>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
