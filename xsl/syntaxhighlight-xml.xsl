<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    exclude-result-prefixes="dc rdfs xh xsd sh"
    xml:lang="en"
    dc:identifier="syntaxhighlight-xml"
    dc:title="Syntax highlighting for XML code"
    dc:creator="https://github.com/rv1971"
    dc:created="2017-09-11"
    dc:modified="2023-05-18">
  <xsd:annotation>
    <xsd:documentation>
      <h2>Introduction</h2>

      <p>Any indentation in the source code is discarded, and new
      indentation is created by this
      stylesheet. <code>&lt;span&gt;</code> elements are used to
      highlight items.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation>
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="sh:indent"
      select="'  '"
      rdfs:label="Indentation string to add on each level of recursion"/>

  <xsl:param
      name="sh:attrIndent"
      select="'    '"
      rdfs:label="Indentation string to add for attributes"/>

  <xsl:param
      name="sh:maxInlineAttrs"
      select="1"
      rdfs:label="Maximum number of inline attributes"/>

  <xsl:param
      name="sh:maxInlineAttrLength"
      select="60"
      rdfs:label="Maximum length of inline attributes"/>

  <xsl:param
      name="sh:maxInlineTextLength"
      select="40"
      rdfs:label="Maximum length of inline text"/>

  <xsd:annotation>
    <xsd:documentation>
      <h2>Auxiliary templates</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="*|@*" mode="sh:prefix"
      rdfs:label="Ignore nodes without prefix"/>

  <xsl:template
      match="*[name() != local-name()]|@*[name() != local-name()]"
      mode="sh:prefix"
      rdfs:label="Format prefix">
    <span class="sh-prefix">
      <xsl:value-of select="substring-before(name(), ':')"/>
    </span>

    <xsl:text>:</xsl:text>
  </xsl:template>

  <xsl:template
      match="*"
      mode="sh:name"
      rdfs:label="Format element name">
    <xsl:apply-templates select="." mode="sh:prefix"/>

    <span class="sh-element">
      <xsl:value-of select="local-name()"/>
    </span>
  </xsl:template>

  <xsl:template
      match="@*"
      mode="sh:name"
      rdfs:label="Format attribute name">
    <xsl:apply-templates select="." mode="sh:prefix"/>

    <span class="sh-attr">
      <xsl:value-of select="local-name()"/>
    </span>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <p>If the current node has at most <a
      href="#sh:maxInlineAttrs">$sh:maxInlineAttrs</a> and the total
      length of their display is at most <a
      href="#sh:maxInlineAttrLength">$sh:maxInlineAttrLength</a>, append
      them to the current line. Otherwise, create a new line for
      each.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="sh:xml-attrs" rdfs:label="Format attributes">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:choose>
      <xsl:when test="count(@*) > $sh:maxInlineAttrs">
        <xsl:apply-templates select="@*" mode="sh:xml">
          <xsl:with-param
              name="prepend"
              select="concat('&#x0a;', $sh:attrIndent, $prepend)"/>
        </xsl:apply-templates>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="inlineAttrs">
          <xsl:apply-templates select="@*" mode="sh:xml">
            <xsl:with-param name="prepend" select="' '"/>
          </xsl:apply-templates>
        </xsl:variable>

        <xsl:choose>
          <xsl:when
              test="string-length($inlineAttrs) > $sh:maxInlineAttrLength">
            <xsl:apply-templates select="@*" mode="sh:xml">
              <xsl:with-param
                  name="prepend"
                  select="concat('&#x0a;', $sh:attrIndent, $prepend)"/>
            </xsl:apply-templates>
          </xsl:when>

          <xsl:otherwise>
            <xsl:copy-of select="$inlineAttrs"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <h2>Syntax highlighting</h2>

      <p>The templates with mode <code>sh:xml</code> generate
      formatted XML code with indentation and syntax
      highlighting.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation>
      <p>Apply <code>normalize-space()</code> and indentation to any
      text nodes except those within <code>&lt;xsl:text></code>
      elements.</p>

      <p>Wrap the result into <code>&lt;span class="sh-text"></code>
      if nonempty.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="text()" mode="sh:xml" rdfs:label="Create text &lt;span>">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:variable name="normalizedText" select="normalize-space()"/>

    <xsl:if test="$normalizedText">
      <xsl:choose>
        <xsl:when test="string-length($normalizedText) &lt;= $sh:maxInlineTextLength">
          <span class="sh-text">
            <xsl:value-of select="$normalizedText"/>
          </span>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="concat('&#x0a;', $prepend)"/>

          <span class="sh-text">
            <xsl:value-of select="$normalizedText"/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xsl:text/text()" mode="sh:xml">
    <span class="sh-text">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <p>Surround comment nodes by empty lines and wrap them into
      <code>&lt;span class="sh-comment"></code>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="comment()"
      mode="sh:xml"
      rdfs:label="Create comment &lt;span>">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <span class="sh-comment">
      <xsl:value-of
          select="concat('&#x0a;&#x0a;', $prepend, '&lt;!--', ., '-->&#x0a;')"/>
    </span>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <p>Attribute nodes are subdivided into the prefix (if any), the
      name and the value, which are then wrapped into <code>&lt;span
      class="sh-prefix"></code>, <code>&lt;span class="sh-attr"></code>
      and <code>&lt;span class="sh-attr-value"></code>,
      respectively.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="@*" mode="sh:sep" rdfs:label="Create '='">
    <xsl:text>=</xsl:text>
  </xsl:template>

  <xsl:template
      match="@*"
      mode="sh:value"
      rdfs:label="Create &lt;span> for an attribute">
    <span class="sh-attr-value">
      <xsl:value-of select="concat('&quot;', ., '&quot;')"/>
    </span>
  </xsl:template>

  <xsl:template
      match="@*"
      mode="sh:xml"
      rdfs:label="Create &lt;span>s for an attribute">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:value-of select="$prepend"/>

    <xsl:apply-templates select="." mode="sh:name"/>

    <xsl:apply-templates select="." mode="sh:sep"/>

    <xsl:apply-templates select="." mode="sh:value"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <p>Transform element nodes recursively to XHTML. Surround
      elements having child elements by empty lines.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="sh:xml" rdfs:label="Format an element">
    <xsl:param
        name="lf"
        rdfs:label="Linefeed string to insert at the beginning"/>
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

      <!-- Determine the preceding element or comment. -->

      <xsl:variable
          name="preceding"
          select="(preceding-sibling::*|preceding-sibling::comment())[last()]"/>

    <!-- insert spacing unless the preceding element is an annotation -->

    <xsl:if test="local-name($preceding) != 'annotation'">
      <!-- Insert a line break if requested by the parameter lf. -->

      <xsl:value-of select="$lf"/>

      <!-- Surround elements having child elements by empty lines;
           i.e. insert a line break before an element if either the
           preceding-element-or-comment has child elements or child
           text nodes, or the current one has child elements and the
           preceding-element-or-comment is not a comment. -->

      <xsl:if
          test="($preceding/*|$preceding/text()[string-length() &gt;= $sh:maxInlineTextLength] or *|text()[string-length() &gt;= $sh:maxInlineTextLength] and name($preceding))">
        <xsl:value-of select="$lf"/>
      </xsl:if>
    </xsl:if>

    <xsl:choose>
      <!-- elements with child nodes -->

      <xsl:when test="./node()">
        <xsl:value-of select="concat($prepend, '&lt;')"/>

        <xsl:apply-templates select="." mode="sh:name"/>

        <xsl:apply-templates select="." mode="sh:xml-attrs">
          <xsl:with-param name="prepend" select="$prepend"/>
        </xsl:apply-templates>

        <xsl:text>&gt;</xsl:text>

        <xsl:apply-templates select="*|text()|comment()" mode="sh:xml">
          <xsl:with-param name="lf" select="'&#x0a;'"/>
          <xsl:with-param name="prepend" select="concat($prepend, $sh:indent)"/>
        </xsl:apply-templates>

        <xsl:if test="*|text()[string-length(normalize-space()) &gt; $sh:maxInlineTextLength]|comment()">
          <xsl:value-of select="concat('&#x0a;', $prepend)"/>
        </xsl:if>

        <xsl:text>&lt;/</xsl:text>
        <xsl:apply-templates select="." mode="sh:name"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>

      <!-- elements without child nodes -->

      <xsl:otherwise>
        <xsl:value-of select="concat($prepend, '&lt;')"/>

        <xsl:apply-templates select="." mode="sh:name"/>

        <xsl:apply-templates select="." mode="sh:xml-attrs">
          <xsl:with-param name="prepend" select="$prepend"/>
        </xsl:apply-templates>

        <xsl:text>/&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
