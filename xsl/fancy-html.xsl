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
    dc:identifier="fancy"
    dc:title="Fancy representation of content"
    dc:creator="rv1971@web.de"
    dc:created="2023-04-13"
    dc:modified="2023-04-18">
  <xsl:import href="fancy.xsl"/>

  <xsd:annotation>
    <xsd:documentation>
      <h2 id="mailto-links"><code>mailto:</code> links</h2>

      <p>Create a <code>mailto</code> link if the value contains a
      <code>@</code>. Also works with values that are already
      <code>mailto:</code> URLs and with values of the form <code>Bob
      &lt;bob@example.org&gt;</code>. If the value contains an
      <code>@</code>, display the part before it.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:mailto"
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

  <xsl:template match="*|@*" mode="a:mailto">
    <xsl:call-template name="a:mailto"/>
  </xsl:template>

  <xsl:template
      name="a:agent"
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

  <xsl:template match="*|@*" mode="a:agent">
    <xsl:call-template name="a:agent"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <h2 id="token lists">Token lists</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:tokens2items"
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

  <xsl:template match="*|@*" mode="a:tokens2items">
    <xsl:call-template name="a:tokens2items"/>
  </xsl:template>

  <xsl:template
      name="a:tokens2links"
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

  <xsl:template match="*|@*" mode="a:tokens2links">
    <xsl:param
        name="urlPrefix"
        select="'#'"
        rdfs:label="URL to prepend to link targets"/>

    <xsl:call-template name="a:tokens2links">
      <xsl:with-param name="urlPrefix" select="$urlPrefix"/>
    </xsl:call-template>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <h2 id="element-creation">Element creation</h2>
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
    <xsd:documentation>
      <h2 id="auto-mode"><code>auto</code> mode</h2>
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
