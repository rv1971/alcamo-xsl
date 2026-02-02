<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    version="1.0"
    exclude-result-prefixes="a dc owl rdf rdfs xi xsd"
    xml:lang="en"
    dc:identifier="markdown.alone"
    dc:title="Markdown generation"
    dc:creator="https://github.com/rv1971"
    dc:created="2026-02-02"
    dc:modified="2026-02-02">
  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>General-purpose templates that generate Markdown code.</p>

      <p>A stylesheet tha creates markdown should contain an element
      such as <code>&lt;xsl:output method="text" encoding="UTF-8"
      media-type="text/markdown"/&gt;</code>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation>
      <h2>CommonMark generation</h2>

      <p>Templates to create Markdown conforming with the <a
      href="https://spec.commonmark.org">CommonMark Spec</a>.</p>
    </xsd:documentation>

    <h3>Limits</h3>

    <p>Line breaks in text are copied unchanged from source, no
    re-folding takes place. This may lead to unsatisfactorily long
    lines.</p>

    <p>Content of <code>&lt;code&gt;</code> is passed through
    <code>normalize-space()</code>. Probably this will not make any
    difference in real life.</p>
  </xsd:annotation>

  <xsl:template
      name="a:md-append-space"
      rdfs:label="Append a space if followed by a sibling which is no punctuation character">
    <xsl:if test="following-sibling::node() and translate(substring(following-sibling::node(), 1, 1), '!,.:;?', '......') != '.'">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="a:md-open-block">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="structure-indicator" select="''"/>

    <xsl:value-of select="$line-prefix"/>
    <xsl:text>
</xsl:text>

    <xsl:value-of select="concat($line-prefix, $structure-indicator)"/>
  </xsl:template>

  <xsl:template name="a:md-empty-line">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:value-of select="$line-prefix"/>

    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template name="a:md-create-block">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="structure-indicator" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:value-of select="concat($line-prefix, $structure-indicator)"/>

    <xsl:copy-of select="$content"/>

    <xsl:value-of select="$line-prefix"/>

    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template name="a:md-text" match="node()" mode="a:md-text">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>
    <xsl:param name="is-first" select="true()"/>
    <xsl:param name="append-newline" select="true()"/>

    <xsl:if test="$content">
      <xsl:variable
          name="line"
          select="normalize-space(substring-before(concat($content, '&#x0a;'), '&#x0a;'))"/>

      <xsl:variable
          name="remainder"
          select="substring-after($content, '&#x0a;')"/>

      <xsl:choose>
        <xsl:when test="$is-first">
          <xsl:value-of select="$line"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="concat($line-prefix, $line)"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="$append-newline or $remainder">
    <xsl:text>
</xsl:text>
      </xsl:if>

      <xsl:if test="$remainder">
        <xsl:call-template name="a:md-text">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
          <xsl:with-param name="content" select="$remainder"/>
          <xsl:with-param name="is-first" select="false()"/>
          <xsl:with-param name="append-newline" select="$append-newline"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="a:md-code" match="node()" mode="a:md-code">
    <xsl:param name="content" select="."/>

    <xsl:text>`</xsl:text>
    <xsl:copy-of select="$content"/>
    <xsl:text>`</xsl:text>
  </xsl:template>

  <xsl:template name="a:md-em" match="node()" mode="a:md-em">
    <xsl:param name="content" select="."/>

    <xsl:value-of select="'*'"/>
    <xsl:copy-of select="$content"/>
    <xsl:value-of select="'*'"/>
  </xsl:template>

  <xsl:template name="a:md-h1" match="node()" mode="a:md-h1">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="structure-indicator" select="'# '"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-h2" match="node()" mode="a:md-h2">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="structure-indicator" select="'## '"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-h3" match="node()" mode="a:md-h3">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="structure-indicator" select="'### '"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-h4" match="node()" mode="a:md-h4">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="structure-indicator" select="'#### '"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-h5" match="node()" mode="a:md-h5">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="structure-indicator" select="'##### '"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-h6" match="node()" mode="a:md-h6">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="structure-indicator" select="'###### '"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-hr" match="node()" mode="a:md-hr">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="structure-indicator" select="'***'"/>
      <xsl:with-param name="content" select="'&#x0a;'"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-li" match="node()" mode="a:md-li">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="list-marker" select="'*'"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param
          name="structure-indicator"
          select="concat($list-marker, ' ')"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-p" match="node()" mode="a:md-p">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:call-template name="a:md-create-block">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-pre" match="node()" mode="a:md-pr">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="content" select="."/>

    <xsl:value-of select="$line-prefix"/>
    <xsl:text>~~~
</xsl:text>

    <xsl:apply-templates select="." mode="a:md-text">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="is-first" select="false()"/>
    </xsl:apply-templates>

    <xsl:value-of select="$line-prefix"/>
    <xsl:text>~~~
</xsl:text>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="a:md-strong" match="node()" mode="a:md-strong">
    <xsl:param name="content" select="."/>

    <xsl:value-of select="'**'"/>
    <xsl:copy-of select="$content"/>
    <xsl:value-of select="'**'"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <h2>CommonMark generation from HTML</h2>

      <p>Templates to create CommonMark from HTML elements.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="text()[normalize-space() = '']" mode="a:md"/>

  <xsl:template match="text()" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="append-newline" select="true()"/>

    <xsl:apply-templates select="." mode="a:md-text">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param
          name="append-newline"
          select="$append-newline and not(following-sibling::node())"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xh:blockquote" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:apply-templates mode="a:md">
      <xsl:with-param name="line-prefix" select="concat('> ', $line-prefix)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xh:code" mode="a:md">
    <xsl:if test="preceding-sibling::node()">
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:call-template name="a:md-code">
      <xsl:with-param name="content" select="normalize-space()"/>
    </xsl:call-template>

    <xsl:call-template name="a:md-append-space"/>
  </xsl:template>

  <xsl:template match="xh:em|xh:i" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:if test="preceding-sibling::node()">
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:call-template name="a:md-em">
      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
          <xsl:with-param name="append-newline" select="false()"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="a:md-append-space"/>
  </xsl:template>

  <xsl:template match="xh:h1" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-h1">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:h2" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-h2">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:h3" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-h3">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:h4" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-h4">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:h5" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-h5">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:h6" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-h6">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:hr" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-hr">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:li" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>
    <xsl:param name="list-marker" select="'*'"/>

    <xsl:call-template name="a:md-li">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="list-marker" select="$list-marker"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param
              name="line-prefix"
              select="concat($line-prefix, '   ')"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:ol" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:apply-templates mode="a:md">
      <xsl:with-param
          name="line-prefix"
          select="concat($line-prefix, '   ')"/>
      <xsl:with-param name="list-marker" select="'1.'"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xh:p" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-p">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>

      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:p[parent::xh:li][position() = 1]" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:apply-templates mode="a:md">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:apply-templates>

    <xsl:call-template name="a:md-empty-line">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:pre" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:call-template name="a:md-pre">
      <xsl:with-param name="line-prefix" select="$line-prefix"/>
      <xsl:with-param name="content" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xh:strong|xh:b" mode="a:md">
    <xsl:param name="line-prefix" select="''"/>

    <xsl:if test="preceding-sibling::node()">
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:call-template name="a:md-strong">
      <xsl:with-param name="content">
        <xsl:apply-templates mode="a:md">
          <xsl:with-param name="line-prefix" select="$line-prefix"/>
          <xsl:with-param name="append-newline" select="false()"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="a:md-append-space"/>
  </xsl:template>

</xsl:stylesheet>
