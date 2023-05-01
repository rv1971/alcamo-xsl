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
    xmlns:axsl="tag:rv1971@web.de,2021:alcamo-xsl:xsl#"
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    exclude-result-prefixes="a axsl dc rdfs sh xh xsd"
    xml:lang="en"
    dc:identifier="xsl"
    dc:title="Format an XSLT stylesheet for human readers"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-18"
    dc:modified="2023-04-24">
  <xsl:import href="annotation.xsl"/>
  <xsl:import href="html-document.xsl"/>
  <xsl:import href="syntaxhighlight-xml.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>This stylesheet is used to format stylesheets for human
      readers.</p>

      <p>You may insert <code>&lt;xsd:annotation></code> elements
      containing <code>&lt;xsd:documentation></code> at the top level
      into the source documents. Such documentation blocks may contain
      level 2 and level 3 headings; there must be at least one such
      heading at the beginning of the source document because the
      table of contents relies on this.</p>

      <p>Each top-level element other than documentation gets a level
      3 heading. The stylesheet generates a table of contents from all
      level 2 and 3 headings. If there are imports and there is a
      level 2 heading containing exactly the word
      <code>Introduction</code>, the whole documentation block is
      copied to the output before the imports, even though in the
      source document the imports necessarily precede the
      documentation.</p>

      <p>A documentation block that contains no headings and is
      immediately followed by a non-XSD element is expected to
      document that element and copied to the output <i>after</i> the
      level 3 heading. To make this work correctly, documentation
      blocks containing headings and documentation blocks explaining
      the immediately following element must be contained in distinct
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
      select="concat($a:xslDirUrl, 'css/alcamo.css', ' ', $a:xslDirUrl, 'css/syntaxhighlight.css', ' ', $a:xslDirUrl, 'css/xsl.css')"/>

  <xsl:param name="sh:maxInlineAttrs" select="3"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Variables</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:variable
      name="axsl:intro"
      select="/*/xsd:annotation[xsd:documentation/xh:h2[. = 'Introduction']]"
      rdfs:label="Annotation containing introduction heading, if any"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Headings</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="/*/*"
      mode="a:title"
      rdfs:label="Create heading text">
    <xsl:value-of select="'Data '"/>

    <code>
      <xsl:value-of select="name(.)"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:key" mode="a:title">
    <xsl:value-of select="'Key '"/>

    <code>
      <xsl:value-of select="@name"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:param" mode="a:title">
    <xsl:value-of select="'Parameter '"/>

    <code>
      <xsl:value-of select="concat('$', @name)"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:template[@name]" mode="a:title">
    <xsl:value-of select="'Template '"/>

    <code>
      <xsl:value-of select="@name"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:template[@match]" mode="a:title">
    <xsl:value-of select="'Template '"/>

    <code>
      <xsl:value-of select="@match"/>
    </code>
  </xsl:template>

  <xsl:template
      match="/*/xsl:template[@match][@mode]"
      mode="a:title">
    <xsl:value-of select="'Template '"/>

    <code>
      <xsl:value-of select="@match"/>
    </code>

    <xsl:value-of select="' mode '"/>

    <code>
      <xsl:value-of select="@mode"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:variable" mode="a:title">
    <xsl:value-of select="'Variable '"/>

    <code>
      <xsl:value-of select="concat('$', @name)"/>
    </code>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Document body</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="xsl:param" mode="axsl:tr" rdfs:label="Create &lt;tr&gt;">
    <tr>
      <td class="code">
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

  <xsl:template
      match="*"
      mode="axsl:inner"
      rdfs:label="In general no further documentation inside"/>

  <xsl:template
      match="xsl:template"
      mode="axsl:inner"
      rdfs:label="Create &lt;table&gt; of parameters, if any">
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
          <xsl:apply-templates select="xsl:param" mode="axsl:tr"/>
        </tbody>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template
      match="*"
      mode="axsl:main"
      rdfs:label="Create documentation for an XSLT or embedded data element">
    <xsl:apply-templates select="." mode="a:h3"/>

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

    <xsl:apply-templates select="." mode="axsl:inner"/>

    <pre>
      <xsl:apply-templates select="." mode="sh:xml"/>
    </pre>
  </xsl:template>

  <xsl:template
      match="xsl:import"
      mode="axsl:main"
      rdfs:label="Ignore &lt;xsl:import&gt; elements here since imports are handled separately"/>

  <xsl:template
      match="xsd:annotation"
      mode="axsl:main"
      rdfs:label="Ignore &lt;xsd:annotation&gt; elements handled by immediately following xsl or embedded data element"/>

  <xsl:template
      match="xsd:annotation[xsd:documentation/xh:h2|xsd:documentation/xh:h3 or not(following-sibling::*)]"
      mode="axsl:main"
      rdfs:label="Copy documentation blocks if they contain headings or are the last top-level element">
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

  <xsl:template
      match="xh:h2"
      mode="axsl:toc-li"
      rdfs:label="Create &lt;li&gt; for the TOC">
    <li>
      <p>
        <xsl:apply-templates select="." mode="a:a"/>
      </p>

      <!-- Get the set of all following top-level non-XSD elements. -->

      <xsl:variable
          name="topf"
          select="following::*[parent::xsl:stylesheet][not(self::xsd:*)]"/>

      <!-- Get the next <xsd:annotation> element containing an <h2>
           element, if any. -->

      <xsl:variable
          name="xsdf"
          select="following::xsd:annotation[xsd:documentation/xh:h2][1]"/>

      <xsl:variable name="subToc">
        <xsl:choose>
          <xsl:when test="$xsdf">
            <xsl:apply-templates
                select="$xsdf/preceding::*[count($topf | .) = count($topf)]|following-sibling::xh:h3"
                mode="a:li-a"/>
          </xsl:when>

          <xsl:otherwise>
            <xsl:apply-templates
                select="$topf|following-sibling::xh:h3"
                mode="a:li-a"/>
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

  <xsl:template name="a:toc" rdfs:label="Create TOC &lt;ul&gt;">
    <ul id="toc">
     <xsl:if test="$axsl:intro">
       <li>
         <p>
           <a href="#introduction">Introduction</a>
         </p>
       </li>
      </xsl:if>

      <xsl:if test="/*/xsl:import">
         <li>
           <p><a href="#imports">Imports</a></p>
         </li>
      </xsl:if>

      <xsl:apply-templates
          select="/*/xsd:annotation/xsd:documentation/xh:h2[. != 'Introduction']"
          mode="axsl:toc-li"/>
      <li>
        <p>
          <a href="#xslt-references">XSLT references</a>
        </p>
      </li>
    </ul>
  </xsl:template>

  <xsl:template
      match="xsl:import"
      mode="axsl:import"
      rdfs:label="Create import &lt;li&gt;">
    <li>
      <a href="{@href}">
        <xsl:value-of select="@href"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template
      name="axsl:imports"
      rdfs:label="Create imports &lt;h2&gt; and  &lt;ul&gt;">
    <h2 id="imports">Imports</h2>

    <ul>
      <xsl:apply-templates select="/*/xsl:import" mode="axsl:import"/>
    </ul>
  </xsl:template>

  <xsl:template
      name="axsl:references"
      rdfs:label="Create references &lt;h2&gt; and  &lt;ul&gt;">
    <h2 id="xslt-references">XSLT references</h2>

    <ul>
      <li><a href="http://www.w3.org/TR/xslt10">XSL Transformations
      (XSLT) 1.0</a></li>
      <li><a href="https://www.w3.org/TR/1999/REC-xpath-19991116">XML
      Path Language (XPath) 1.0</a></li>
    </ul>
  </xsl:template>

  <xsl:template name="a:page-main">
    <xsl:if test="$axsl:intro">
      <xsl:apply-templates select="$axsl:intro" mode="axsl:main"/>
    </xsl:if>

    <xsl:if test="/*/xsl:import">
      <xsl:call-template name="axsl:imports"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$axsl:intro">
        <xsl:apply-templates select="/*/*[. != $axsl:intro]" mode="axsl:main"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates select="/*/*" mode="axsl:main"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="axsl:references"/>
  </xsl:template>
</xsl:stylesheet>
