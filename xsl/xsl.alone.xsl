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
    dc:identifier="xsl.alone"
    dc:title="Format an XSLT stylesheet for human readers"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-18"
    dc:modified="2023-11-20">
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

      <p>All HTML dcoumentation is expected to be placed inside such
      blocks. Top-level HTML elements are ignored.</p>

      <p>Each top-level element other than documentation gets a level
      3 heading. The stylesheet generates a table of contents from all
      level 2 and 3 headings. If there are imports and there is a
      level 2 heading containing exactly the word
      <code>Introduction</code>, the whole documentation block is
      copied to the output <i>before</i> the imports, even though in
      the source document the imports necessarily precede the
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
      <h2>Variables</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:variable
      name="axsl:intro"
      select="/*/xsd:annotation[xsd:documentation/xh:h2[. = 'Introduction']]"
      rdfs:label="Annotation containing introduction heading, if any"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Name generation</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="/*/*" mode="a:name" rdfs:label="Create name text">
    <xsl:text>Data </xsl:text>

    <code>
      <xsl:value-of select="name()"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:key" mode="a:name">
    <xsl:text>Key </xsl:text>

    <code>
      <xsl:value-of select="@name"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:param" mode="a:name">
    <xsl:text>Parameter </xsl:text>

    <code>
      <xsl:value-of select="concat('$', @name)"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:template[@name]" mode="a:name">
    <xsl:text>Template </xsl:text>

    <code>
      <xsl:value-of select="@name"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:template[@match]" mode="a:name">
    <xsl:text>Template </xsl:text>

    <code>
      <xsl:value-of select="@match"/>
    </code>
  </xsl:template>

  <xsl:template
      match="/*/xsl:template[@match][@mode]"
      mode="a:name">
    <xsl:text>Template </xsl:text>

    <code>
      <xsl:value-of select="@match"/>
    </code>

    <xsl:text> mode </xsl:text>

    <code>
      <xsl:value-of select="@mode"/>
    </code>
  </xsl:template>

  <xsl:template match="/*/xsl:variable" mode="a:name">
    <xsl:text>Variable </xsl:text>

    <code>
      <xsl:value-of select="concat('$', @name)"/>
    </code>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>ID generation</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="xsl:*" mode="a:id" rdfs:label="Create ID from title">
    <xsl:call-template name="a:id"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Syntax highlight</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xsl:*|attribute::xsl:*"
      mode="sh:prefix"
      rdfs:label="Format prefix">
    <span class="sh-prefix bold">
      <xsl:value-of select="substring-before(name(), ':')"/>
    </span>

    <xsl:text>:</xsl:text>
  </xsl:template>

  <xsl:template
      match="text()[parent::xsl:message]"
      mode="sh:xml"
      rdfs:label="Highlight xsl:message content">
    <span class="error">
      <xsl:apply-imports/>
    </span>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Document body</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="*"
      mode="axsl:inner"
      rdfs:label="In general no further documentation inside"/>

  <xsl:template
      match="xsl:template"
      mode="axsl:inner"
      rdfs:label="Create &lt;table&gt; of parameters, if any">
    <xsl:if test="xsl:param">
      <table class="alcamo">
        <thead>
          <tr>
            <th>Parameter</th>
            <th>Description</th>
            <th>Default</th>
          </tr>
        </thead>

        <tbody>
          <xsl:for-each select="xsl:param">
            <tr>
              <td class="code">
                <xsl:value-of select="@name"/>
              </td>

              <td>
                <xsl:apply-templates select="@rdfs:comment" mode="a:auto"/>
                <xsl:value-of select="@rdfs:label"/>
              </td>

              <td class="code">
                <xsl:value-of select="@select"/>
              </td>
            </tr>
          </xsl:for-each>
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
        select="preceding-sibling::*[1][self::xsd:annotation/xsd:documentation/xh:*]"/>

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
      match="xsl:namespace-alias"
      mode="axsl:main"
      rdfs:label="Ignore &lt;xsl:namespace-alias&gt; elements here since imports are handled separately"/>

  <xsl:template
      match="xsl:namespace-alias[1]"
      mode="axsl:main"
      rdfs:label="Create namespace-aliases &lt;table&gt;">
    <table class="alcamo">
      <thead>
        <tr>
          <th colspan="2">Stylesheet</th>
          <th colspan="2">Result</th>
        </tr>
      </thead>

      <tbody class="code">
        <xsl:for-each select="/*/xsl:namespace-alias">
          <tr>
            <td>
              <xsl:value-of select="@stylesheet-prefix"/>
            </td>

            <td>
              <xsl:value-of
                  select="namespace::*[name() = current()/@stylesheet-prefix]"/>
            </td>

            <td>
              <xsl:value-of select="@result-prefix"/>
            </td>

            <td>
              <xsl:value-of
                  select="namespace::*[name() = current()/@result-prefix]"/>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

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

      <!-- Get the set of all following top-level non-XSD
           non-namespace-alias elements. -->

      <xsl:variable
          name="topf"
          select="following::*[parent::xsl:stylesheet][not(self::xsd:*)][not(self::xsl:namespace-alias)]"/>

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

      <xsl:if test="$subToc != ''">
        <ul>
          <xsl:copy-of select="$subToc"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Create an automatic heading for the first
      <code>&lt;xsl:import&gt;</code> element. This is necessary because
      it is not allowed to include any other elements (including
      documentation) before <code>&lt;xsl:import&gt;</code> elements.</p>

      <p>Also create automatic heading for the first
      <code>&lt;xsl:namespace-alias&gt;</code> element. This is useful
      because all namespace aliases are summarized in one section.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="/xsl:*" mode="a:toc" rdfs:label="Create TOC &lt;ul&gt;">
    <ul id="toc">
     <xsl:if test="$axsl:intro">
       <li>
         <p>
           <a href="#introduction">Introduction</a>
         </p>
       </li>
      </xsl:if>

      <xsl:if test="xsl:import">
         <li>
           <p><a href="#imports">Imports</a></p>
         </li>
      </xsl:if>

      <xsl:apply-templates
          select="xsd:annotation/xsd:documentation/xh:h2[. != 'Introduction']"
          mode="axsl:toc-li"/>

      <li>
        <p>
          <a href="#appendix">Appendix</a>
        </p>
        <ul>
          <li>
            <p>
              <a href="#modes-defined">Modes defined</a>
            </p>
          </li>

          <xsl:if test="xsl:*[@name]">
            <li>
              <p>
                <a href="#named-elements">Named elements</a>
              </p>
            </li>
          </xsl:if>

          <li>
            <p>
              <a href="#xslt-references">XSLT references</a>
            </p>
          </li>
        </ul>
      </li>
    </ul>
  </xsl:template>

  <xsl:template
      match="*"
      mode="axsl:imports"
      rdfs:label="Create imports &lt;h2&gt; and  &lt;ul&gt;">
    <xsl:if test="xsl:import">
      <h2 id="imports">Imports</h2>

      <ul>
        <xsl:apply-templates select="xsl:import/@href" mode="a:li"/>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template
      match="*"
      mode="axsl:modes-defined"
      rdfs:label="Create mixed content">
    <h3 id="modes-defined">Modes defined</h3>

    <table class="alcamo">
      <thead>
        <th>Mode</th>
        <th>Defined for</th>
      </thead>

      <tbody>
        <xsl:for-each select="xsl:template[@mode]">
          <xsl:sort select="@mode"/>
          <xsl:sort select="@match"/>

          <tr class="code">
            <td>
              <xsl:value-of select="@mode"/>
            </td>

            <td>
              <a>
                <xsl:attribute name="href">
                  <xsl:text>#</xsl:text>
                  <xsl:apply-templates select="." mode="a:id"/>
                </xsl:attribute>

                <xsl:value-of select="@match"/>
              </a>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template
      match="*"
      mode="axsl:named-elements"
      rdfs:label="Create mixed content">
    <h3 id="named-elements">Named elements</h3>

    <table class="alcamo">
      <thead>
        <th>Name</th>
        <th>Element type</th>
      </thead>

      <tbody>
        <xsl:for-each select="xsl:*[@name]">
          <xsl:sort select="@name"/>
          <xsl:sort select="local-name()"/>

          <tr class="code">
            <td>
              <xsl:value-of select="@name"/>
            </td>

            <td>
              <a>
                <xsl:attribute name="href">
                  <xsl:text>#</xsl:text>
                  <xsl:apply-templates select="." mode="a:id"/>
                </xsl:attribute>

                <xsl:value-of select="local-name()"/>
              </a>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template
      match="*"
      mode="axsl:references"
      rdfs:label="Create references &lt;h2&gt; and  &lt;ul&gt;">
    <h3 id="xslt-references">XSLT references</h3>

    <ul>
      <li><a href="http://www.w3.org/TR/xslt10">XSL Transformations
      (XSLT) 1.0</a></li>
      <li><a href="https://www.w3.org/TR/1999/REC-xpath-19991116">XML
      Path Language (XPath) 1.0</a></li>
    </ul>
  </xsl:template>

  <xsl:template
      match="*"
      mode="axsl:appendix"
      rdfs:label="Create appendix &lt;h2&gt; and call further templates">
    <h2 id="appendix">Appendix</h2>

    <xsl:apply-templates select="." mode="axsl:modes-defined"/>

    <xsl:if test="xsl:*[@name]">
      <xsl:apply-templates select="." mode="axsl:named-elements"/>
    </xsl:if>

    <xsl:apply-templates select="." mode="axsl:references"/>
  </xsl:template>

  <xsl:template match="*" mode="axsl:collect-errors">
    <xsl:if test="xh:*">
      <p>
There is top-level HTML content in this document. It is not
processed as documentation.
</p>
    </xsl:if>

    <xsl:if test="xsd:documentation">
      <p>
There are top-level &lt;xsd:documentation&gt; elements. They
are not processed as documentation.
</p>
    </xsl:if>

    <xsl:if
        test="xsl:*[not(self::xsl:import)][1][not(preceding-sibling::xsd:annotation/xsd:documentation/xh:h2)]">
      <p>
There is top-level content other than &lt;xsl:import&gt; without a
preceding &lt;h2&gt; in a documentation block. Not TOC entries are
generated for this content.
</p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="a:collect-errors">
    <xsl:apply-templates select="." mode="axsl:collect-errors"/>
  </xsl:template>

  <xsl:template match="/xsl:*" mode="a:page-main">
    <xsl:apply-templates select="$axsl:intro" mode="axsl:main"/>

    <xsl:apply-templates select="." mode="axsl:imports"/>

    <xsl:apply-templates
        select="*[count(.|$axsl:intro) = count($axsl:intro) + 1]"
        mode="axsl:main"/>

    <xsl:apply-templates select="." mode="axsl:appendix"/>
  </xsl:template>
</xsl:stylesheet>
