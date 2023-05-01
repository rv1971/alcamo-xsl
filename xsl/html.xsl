<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

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
    dc:identifier="html"
    dc:title="HTML generation"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2023-05-01">
  <xsl:import href="text.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>General-purpose templates that generate HTML code.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Links to agents</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Create a <code>mailto</code> link if the value contains a
      <code>@</code>. Also works with values that are already
      <code>mailto:</code> URLs and with values of the form <code>Bob
      &lt;bob@example.org&gt;</code>. If the value contains an
      <code>@</code>, display the part before it.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:mailto"
      match="*|@*"
      mode="a:mailto"
      rdfs:label="Create mailto: link if value contains a @">
    <xsl:param name="value" select="." rdfs:label="Value to format"/>

    <xsl:choose>
      <xsl:when test="starts-with($value, 'mailto:')">
        <a href="{$value}">
          <xsl:value-of
              select="substring-before(substring-after($value, 'mailto:'), '@')"/>
        </a>
      </xsl:when>

      <xsl:when test="contains($value, ' &lt;')">
        <a href="mailto:{substring-before(substring-after($value, '&lt;'), '&gt;')}">
          <xsl:value-of select="substring-before($value, ' &lt;')"/>
        </a>
      </xsl:when>

      <xsl:when test="contains($value, '@')">
        <a href="mailto:{$value}">
          <xsl:value-of select="substring-before($value, '@')"/>
        </a>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      name="a:agent"
      match="*|@*"
      mode="a:agent"
      rdfs:label="Create link if value is an URL, else mailto: link if value contains a @">
    <xsl:param name="value" select="." rdfs:label="Value to format"/>

    <xsl:choose>
      <xsl:when test="starts-with($value, 'https://')">
        <a href="{$value}">
          <xsl:value-of
              select="substring-after($value, 'https://')"/>
        </a>
      </xsl:when>

      <xsl:when test="starts-with($value, 'http://')">
        <a href="{$value}">
          <xsl:value-of
              select="substring-after($value, 'http://')"/>
        </a>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="a:mailto">
          <xsl:with-param name="value" select="$value"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Headings</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="a:h2" rdfs:label="Create &lt;h2&gt; with id">
    <h2>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>
    </h2>
  </xsl:template>

  <xsl:template match="*" mode="a:h3" rdfs:label="Create &lt;h3&gt; with id">
    <h3>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>
    </h3>
  </xsl:template>

  <xsl:template match="*" mode="a:h4" rdfs:label="Create &lt;h4&gt; with id">
    <h4>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>
    </h4>
  </xsl:template>

  <xsl:template match="*" mode="a:h5" rdfs:label="Create &lt;h5&gt; with id">
    <h5>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>
    </h5>
  </xsl:template>

  <xsl:template match="*" mode="a:h6" rdfs:label="Create &lt;h6&gt; with id">
    <h6>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>
    </h6>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Links to HTML elements</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="a:a" rdfs:label="Create &lt;a&gt;">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="'#'"/>
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>
    </a>
  </xsl:template>

  <xsl:template
      match="*"
      mode="a:li-a"
      rdfs:label="Create &lt;li&gt; containing &lt;a&gt;">
    <li>
      <xsl:apply-templates select="." mode="a:a"/>
    </li>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Token lists</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:tokens2items"
      match="*|@*"
      mode="a:tokens2items"
      rdfs:label="Create &lt;li&gt;s from a whitespace-separated list">
    <xsl:param
        name="tokens"
        select="normalize-space(.)"
        rdfs:label="space-separated list of remaining tokens"/>

    <xsl:if test="$tokens">
      <xsl:variable
          name="item"
          select="substring-before(concat($tokens, ' '), ' ')"/>

      <li>
        <xsl:value-of select="$item"/>
      </li>

      <xsl:if test="substring-after($tokens, ' ')">
        <xsl:call-template name="a:tokens2items">
          <xsl:with-param name="tokens" select="substring-after($tokens, ' ')"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template
      name="a:tokens2links"
      match="*|@*"
      mode="a:tokens2links"
      rdfs:label="Create &lt;li&gt;s containing &lt;a&gt;s from a whitespace-separated list">
    <xsl:param
        name="tokens"
        select="normalize-space(.)"
        rdfs:label="Space-separated list of remaining tokens"/>
    <xsl:param
        name="urlPrefix"
        select="'#'"
        rdfs:label="URL to prepend to link targets"/>

    <xsl:if test="$tokens">
      <xsl:variable
          name="item"
          select="substring-before(concat($tokens, ' '), ' ')"/>

      <li>
        <a href="{$urlPrefix}{$item}">
          <xsl:value-of select="$item"/>
        </a>
      </li>

      <xsl:if test="substring-after($tokens, ' ')">
        <xsl:call-template name="a:tokens2links">
          <xsl:with-param name="tokens" select="substring-after($tokens, ' ')"/>
          <xsl:with-param name="urlPrefix" select="$urlPrefix"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Element creation</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*|@*" mode="a:li" rdfs:label="Create &lt;li>">
    <li>
      <xsl:apply-templates select="." mode="a:auto"/>
    </li>
  </xsl:template>

  <xsl:template match="*|@*" mode="a:td" rdfs:label="Create &lt;td>">
    <td>
      <xsl:apply-templates select="." mode="a:auto"/>
    </td>
  </xsl:template>

  <xsl:template
      match="*|@*"
      mode="a:th"
      rdfs:label="Create &lt;th> containing local node name">
    <th>
      <xsl:value-of select="local-name(.)"/>
    </th>
  </xsl:template>

  <xsl:template
      match="*|@*"
      mode="a:tr"
      rdfs:label="Create &lt;tr> using a:th and a:td">
    <tr>
      <xsl:apply-templates select="." mode="a:th"/>
      <xsl:apply-templates select="." mode="a:td"/>
    </tr>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Metadata</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:created-modified"
      rdfs:label="Create last modification timestamp, potentially with tooltip about creation timestamp">
    <xsl:param
        name="created"
        select="$dc:created"
        rdfs:label="Creation timestamp"/>
    <xsl:param
        name="modified"
        select="$dc:modified"
        rdfs:label="Modification timestamp"/>

    <xsl:choose>
      <xsl:when test="$modified">
        <xsl:choose>
          <xsl:when test="$created">
            <span>
              <xsl:attribute name="title">
                <xsl:value-of select="'created '"/>
                <xsl:apply-templates
                    select="$created"
                    mode="a:iso-8583-timestamp"/>
              </xsl:attribute>

              <xsl:apply-templates
                  select="$modified"
                  mode="a:iso-8583-timestamp"/>
            </span>
          </xsl:when>

          <xsl:otherwise>
            <xsl:apply-templates
                select="$modified"
                mode="a:iso-8583-timestamp"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$created">
        <xsl:apply-templates
            select="$created"
            mode="a:iso-8583-timestamp"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*|@*" mode="a:created-modified">
    <xsl:call-template name="a:created-modified">
      <xsl:with-param name="created" select="@dc:created"/>
      <xsl:with-param name="modified" select="@dc:modified"/>
    </xsl:call-template>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2><code>auto</code> mode</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="@dc:creator|dc:creator|@dc:publisher|dc:publisher|@dc:rightsHolder|dc:rightsHolder"
      mode="a:auto"
      rdfs:label="Call a:agent">
    <xsl:call-template name="a:agent"/>
  </xsl:template>

  <xsl:template
      match="@rdfs:comment|rdfs:comment"
      mode="a:auto"
      rdfs:label="Create title attribute">
    <xsl:attribute name="title">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
