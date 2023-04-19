<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    xmlns:ax="tag:rv1971@web.de,2021:alcamo-xsl:xslt#"
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    exclude-result-prefixes="a ax rdfs sh xsd"
    xml:lang="en"
    dc:identifier="html-output"
    dc:title="Format an XSLT stylesheet for human readers"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-18"
    dc:modified="2023-04-18">
  <xsl:import href="annotation.xsl"/>
  <xsl:import href="html.xsl"/>
  <xsl:import href="html-output.xsl"/>
  <xsl:import href="metadata.xsl"/>
  <xsl:import href="syntaxhighlight-xml.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>This stylesheet is used to format stylesheets for human
      readers. You may insert <code>&lt;xsd:annotation></code>
      elements containing <code>&lt;xsd:documentation></code> at the
      top level into the source documents. Such documentation
      blocks may contain level 2 headings.</p>

      <p>Each top-level element other than documentation gets a level
      3 heading. The stylesheet generates a table of contents from all
      level 2 and 3 headings. If there are imports and there is a
      level 2 heading containing exactly the word
      <code>Introduction</code>, the whole documentation block is
      output before the imports, even though in the source document
      the imports necessarily precede the documentation.</p>

      <p>To make the automatic creation of section titles work
      correctly, documentation blocks containing an
      <code>&lt;h2></code> element and documentation blocks explaining
      a single subsequent element must be contained in distinct
      <code>&lt;xsd:annotation></code> elements.</p>

      <p>Content of <code>&lt;xsd:documentation></code> within
      top-level <code>&lt;xsd:annotation></code> is copied almost
      unchanged to the output. Any other top-level XML elements are
      formatted as source code with <a
      href="syntaxhighlight-xml.xsl">syntax highlighting</a>. As a
      consequence, top-level comments are deliberately ignored, since
      documentation of top-level items should be done via
      <code>&lt;xsd:annotation></code> and not via comments.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="a:cssList"
      rdfs:label="Whitespace-separated list of CSS files to link to"
      select="concat($a:xslDirUrl, 'css/alcamo.css', ' ', $a:xslDirUrl, 'css/syntaxhighlight.css', ' ', $a:xslDirUrl, 'css/xsl.css')"/>

  <xsl:param name="sh:maxInlineAttrs" select="3"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Variables</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:variable
      name="ax:intro"
      select="/*/xsd:annotation[xsd:documentation/xh:h2[. = 'Introduction']]"
      rdfs:label="Annotation containing introduction heading"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Headings</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="*"
      mode="a:label"
      rdfs:label="Create heading text">
    <xsl:value-of select="'Data '"/>

    <code>
      <xsl:value-of select="name(.)"/>
    </code>
  </xsl:template>

  <xsl:template match="xh:h2" mode="a:label">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="xsl:key" mode="a:label">
    <xsl:value-of select="'Key '"/>

    <code>
      <xsl:value-of select="@name"/>
    </code>
  </xsl:template>

  <xsl:template match="xsl:param[@name]" mode="a:label">
    <xsl:value-of select="'Parameter '"/>

    <code>
      <xsl:value-of select="concat('$', @name)"/>
    </code>
  </xsl:template>

  <xsl:template match="xsl:template[@name]" mode="a:label">
    <xsl:value-of select="'Template '"/>

    <code>
      <xsl:value-of select="@name"/>
    </code>
  </xsl:template>

  <xsl:template match="xsl:template[@match]" mode="a:label">
    <xsl:value-of select="'Template '"/>

    <code>
      <xsl:value-of select="@match"/>
    </code>
  </xsl:template>

  <xsl:template
      match="xsl:template[@match][@mode]"
      mode="a:label">
    <xsl:value-of select="'Template '"/>

    <code>
      <xsl:value-of select="@match"/>
    </code>

    <xsl:value-of select="' mode '"/>

    <code>
      <xsl:value-of select="@mode"/>
    </code>
  </xsl:template>

  <xsl:template match="xsl:variable[@name]" mode="a:label">
    <xsl:value-of select="'Variable '"/>

    <code>
      <xsl:value-of select="concat('$', @name)"/>
    </code>
  </xsl:template>

  <xsl:template match="*" mode="ax:heading">
    <xsl:variable name="text">
      <xsl:apply-templates select="." mode="a:label"/>
    </xsl:variable>

    <h3>
      <xsl:attribute name="id">
        <xsl:call-template name="a:to-id">
          <xsl:with-param name="text" select="$text"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:copy-of select="$text"/>
    </h3>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Document body</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="xsl:param" mode="ax:tr">
    <tr>
      <td>
        <xsl:value-of select="@name"/>
      </td>

      <td>
        <xsl:value-of select="@rdfs:label"/>
      </td>

      <td>
        <xsl:value-of select="@select"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="*" mode="ax:inner"/>

  <xsl:template match="xsl:template" mode="ax:inner">
    <xsl:if test="xsl:param">
      <table class="param-doc">
        <thead>
          <tr>
            <th>Parameter</th>
            <th>Description</th>
            <th>Default</th>
          </tr>
        </thead>

        <tbody>
          <xsl:apply-templates select="xsl:param" mode="ax:tr"/>
        </tbody>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="ax:main">
    <xsl:apply-templates select="." mode="ax:heading"/>

    <!-- insert immediately preceding documentation block if the block
         does not contain heading elements. -->
    <xsl:variable
        name="documentation"
        select="preceding::xsd:annotation[1][xsd:documentation/xh:*]"/>

    <xsl:if test="$documentation[not(xsd:documentation/xh:h2)][not(xsd:documentation/xh:h3)]">
      <xsl:apply-templates select="$documentation" mode="a:copy"/>
    </xsl:if>

    <xsl:if test="@rdfs:label">
      <p>
        <xsl:value-of select="@rdfs:label"/>
      </p>
    </xsl:if>

    <xsl:apply-templates select="." mode="ax:inner"/>

    <pre>
      <xsl:apply-templates select="." mode="sh:xml"/>
    </pre>
  </xsl:template>

  <xsl:template match="xsl:import" mode="ax:main"/>

  <xsl:template match="xsd:*" mode="ax:main"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Copy documentation blocks if they contain headings. If they
      don't, they are supposed to document the immediately following
      element and are handled by the template that formats the
      latter.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xsd:annotation[xsd:documentation/xh:h2]|xsd:annotation[xsd:documentation/xh:h2]"
      mode="ax:main"
      rdfs:label="Copy documentation">
    <xsl:apply-templates select="xsd:documentation/xh:*" mode="a:copy"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Create an automatic heading for the first
      <code>&lt;xsl:import&gt;</code> element. This is necessary because
      it is not allowed to include any other elements (including
      documentation) before <code>&lt;xsl:import&gt;</code> elements.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Document skeleton</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="xh:h2" mode="ax:toc-li">
    <li>
      <xsl:apply-templates select="." mode="a:a"/>

      <!-- Get the next <xsd:annotation> element containing an <h2>
           element, if any. -->

      <xsl:variable
          name="xsdf"
          select="following::xsd:annotation[xsd:documentation/xh:h2][1]"/>

      <!-- Get the set of all following top-level non-XSD elements. -->

      <xsl:variable
          name="topf"
          select="following::*[parent::xsl:stylesheet][namespace-uri(.) != 'http://www.w3.org/2001/XMLSchema']"/>

      <xsl:variable name="subToc">
        <xsl:choose>
          <xsl:when test="$xsdf">
            <xsl:apply-templates
                select="$xsdf/preceding::*[count($topf | .) = count($topf)]"
                mode="a:li-a"/>
          </xsl:when>

          <xsl:otherwise>
            <xsl:apply-templates select="$topf" mode="a:li-a"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- If the sub-toc is nonempty, wrap it into a <ul> element. -->

      <xsl:if test="$subToc">
        <ul>
          <xsl:copy-of select="$subToc"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="ax:toc">
    <ul id="toc">
      <xsl:if test="/*/xsl:import">
        <li><a href="#imports">Imports</a></li>
      </xsl:if>

     <xsl:if test="$ax:intro">
        <li><a href="#introduction">Introduction</a></li>
      </xsl:if>

      <xsl:apply-templates
          select="/*/xsd:annotation/xsd:documentation/xh:h2[. != 'Introduction']"
          mode="ax:toc-li"/>
      <li><a href="#xslt-refs">XSLT references</a></li>
    </ul>
  </xsl:template>

  <xsl:template name="ax:page-header">
    <header>
      <h1>
        <xsl:value-of select="$dc:title"/>
      </h1>

      <p>
        <xsl:apply-templates select="$dc:creator" mode="a:agent"/>
        <xsl:value-of select="', '"/>

        <xsl:call-template name="a:created-modified"/>
      </p>

      <xsl:call-template name="ax:toc"/>
    </header>
  </xsl:template>

  <xsl:template
      match="xsl:import"
      mode="ax:import"
      rdfs:label="Create import &lt;li&gt;">
    <li>
      <a href="{@href}">
        <xsl:value-of select="@href"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template
      name="ax:imports"
      rdfs:label="Create imports &lt;h2&gt; and  &lt;ul&gt;">
    <h2 id="imports">Imports</h2>

    <ul>
      <xsl:apply-templates select="/*/xsl:import" mode="ax:import"/>
    </ul>
  </xsl:template>

  <xsl:template
      name="ax:references"
      rdfs:label="Create references &lt;h2&gt; and  &lt;ul&gt;">
    <h2 id="xslt-references">XSLT references</h2>

    <ul>
      <li><a href="http://www.w3.org/TR/xslt10">XSL Transformations
      (XSLT) 1.0</a></li>
      <li><a href="https://www.w3.org/TR/1999/REC-xpath-19991116">XML
      Path Language (XPath) 1.0</a></li>
    </ul>
  </xsl:template>

  <xsl:template match="/" rdfs:label="Create the document">
    <html>
      <xsl:for-each select="$a:metaRoot/@xml:lang">
        <xsl:copy/>
      </xsl:for-each>

      <xsl:call-template name="a:head"/>

      <body>
        <xsl:call-template name="ax:page-header"/>

        <xsl:if test="$ax:intro">
          <xsl:apply-templates select="$ax:intro" mode="ax:main"/>
        </xsl:if>

        <xsl:if test="/*/xsl:import">
          <xsl:call-template name="ax:imports"/>
        </xsl:if>


        <xsl:choose>
          <xsl:when test="$ax:intro">
            <xsl:apply-templates select="/*/*[. != $ax:intro]" mode="ax:main"/>
          </xsl:when>

          <xsl:otherwise>
            <xsl:apply-templates select="/*/*" mode="ax:main"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="ax:references"/>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
