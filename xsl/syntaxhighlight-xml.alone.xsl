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
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    exclude-result-prefixes="a dc rdfs xh xsd sh"
    xml:lang="en"
    dc:identifier="syntaxhighlight-xml.alone"
    dc:title="Syntax highlighting for XML code"
    dc:creator="https://github.com/rv1971"
    dc:created="2017-09-11"
    dc:modified="2024-02-12">
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

  <xsl:template
      match="*"
      mode="sh:xml-attrs"
      rdfs:label="Format attributes and namespace declarations">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:variable name="namespaceDecls">
      <xsl:call-template name="sh:xml-namespace-decls">
        <xsl:with-param
            name="prepend"
            select="concat('&#x0a;', $sh:attrIndent, $prepend)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="count(@*) > $sh:maxInlineAttrs or $namespaceDecls != ''">
        <xsl:copy-of select="$namespaceDecls"/>

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

  <xsl:template match="@*" mode="sh:sep" name="sh:sep" rdfs:label="Create '='">
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

  <xsl:template
      match="node()"
      mode="sh:namespace"
      rdfs:label="Create &lt;span>s for a namespace declaration">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:value-of select="$prepend"/>

    <xsl:apply-templates select="." mode="sh:name"/>

    <xsl:apply-templates select="." mode="sh:sep"/>

    <xsl:apply-templates select="." mode="sh:value"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <p>Namespace declaration nodes are subdivided into the
      <code>xmlns</code>prefix, the declared prefix (if any) and the
      value, which are then wrapped into <code>&lt;span
      class="sh-xmlns-prefix"></code>, <code>&lt;span
      class="sh-prefix"></code> and <code>&lt;span
      class="sh-namespace-uri"></code>, respectively.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="sh:xml-namespace-decl-prefix"
      rdfs:label="Create &lt;span> for a namespace declaration prefix">
    <xsl:choose>
      <xsl:when test="local-name()">
        <span class="sh-xmlns-prefix">xmlns</span>
        <xsl:text>:</xsl:text>

        <span class="sh-prefix">
          <xsl:value-of select="local-name()"/>
        </span>
      </xsl:when>

      <xsl:otherwise>
        <span class="sh-xmlns-prefix">xmlns</span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      name="sh:xml-namespace-uri"
      rdfs:label="Create &lt;span> for a namespace uri">
    <span class="sh-namespace-uri">
      <xsl:text>"</xsl:text>

      <xsl:choose>
        <xsl:when test="starts-with(., 'http')">
          <a href="{.}">
            <xsl:value-of select="."/>
          </a>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>"</xsl:text>
    </span>
  </xsl:template>

  <xsl:template
      name="sh:namespace"
      rdfs:label="Format a namespace declaration">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>
    <xsl:value-of select="$prepend"/>
    <xsl:call-template name="sh:xml-namespace-decl-prefix"/>
    <xsl:call-template name="sh:sep"/>
    <xsl:call-template name="sh:xml-namespace-uri"/>
  </xsl:template>

  <xsl:template
      name="sh:xml-namespace-decls"
      rdfs:label="Format namespace declarations">
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:for-each select="namespace::*">
      <xsl:if
          test="not(../../namespace::*[local-name() = local-name(current()) and string(.) = string(current())])">
        <xsl:call-template name="sh:namespace">
          <xsl:with-param name="prepend" select="$prepend"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <p>Transform element nodes recursively to XHTML. Surround
      elements having child elements by empty lines.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="sh:xml"
      match="*"
      mode="sh:xml"
      rdfs:label="Format an element">
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

  <xsd:annotation>
    <xsd:documentation>
      <h2>HTML handling</h2>

      <p>Copy HTML code unchanged to the result tree. Omit
      <code>&lt;xsd:annotation&gt;/&lt;xsd:documentation&gt;</code>
      surrounding pure HTML content and wrap pure HTML documentation
      blocks into &lt;div&gt; so that CSS can be used to display them
      in non-pre-style.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xh:*"
      mode="sh:xml"
      rdfs:label="Copy HTML code unchanged">
    <xsl:param
        name="lf"
        rdfs:label="Linefeed string to insert at the beginning"/>
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:choose>
      <xsl:when test="$sh:htmlPassthru">
        <xsl:apply-templates select="." mode="a:copy"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="sh:xml">
          <xsl:with-param name="lf" select="$lf"/>
          <xsl:with-param name="prepend" select="$prepend"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      match="xsd:documentation[not(*[not(self::xh:*)])][not(text()[normalize-space()])]"
      mode="sh:xml"
      rdfs:label="Wrap HTML-only documentation into &lt;div&gt;">
    <xsl:param
        name="lf"
        rdfs:label="Linefeed string to insert at the beginning"/>
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:choose>
      <xsl:when test="$sh:htmlPassthru">
        <div>
          <xsl:apply-templates mode="a:copy"/>
        </div>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="sh:xml">
          <xsl:with-param name="lf" select="$lf"/>
          <xsl:with-param name="prepend" select="$prepend"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      match="xsd:annotation[not(*[not(self::xsd:documentation[not(*[not(self::xh:*)])][not(text()[normalize-space()])])])]"
      mode="sh:xml"
      rdfs:label="Omit &lt;xsd:annotation/xsd:documentation&gt; surrounding HTML-only documentation">
    <xsl:param
        name="lf"
        rdfs:label="Linefeed string to insert at the beginning"/>
    <xsl:param name="prepend" rdfs:label="String to prepend to each line"/>

    <xsl:choose>
      <xsl:when test="$sh:htmlPassthru">
        <xsl:apply-templates mode="sh:xml"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="sh:xml">
          <xsl:with-param name="lf" select="$lf"/>
          <xsl:with-param name="prepend" select="$prepend"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
