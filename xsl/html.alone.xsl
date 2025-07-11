<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    version="1.0"
    exclude-result-prefixes="a dc owl rdf rdfs xi xsd"
    xml:lang="en"
    dc:identifier="html.alone"
    dc:title="HTML generation"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2025-06-25">
  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>General-purpose templates that generate HTML code.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Variables</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:variable
      name="a:xpointerToIdStart"
      rdfs:label="String needed to extract an ID from a XPointer">xpointer(id("</xsl:variable>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>External links</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Create a <code>mailto</code> link if the value contains a
      <code>@</code>. Also works with values that are already
      <code>mailto:</code> URLs and with values of the form <code>Bob
      &lt;bob@example.org&gt;</code>. If the value contains an
      <code>@</code>, display the part before it.</p>

      <p>This template rule does not check whether the input is a
      valid literal in one of the supported syntaxes, and gives
      undefined results if this is not the case.</p>
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
      name="a:linkto"
      match="*|@*"
      mode="a:linkto"
      rdfs:label="Create link unless tag URI">
    <xsl:param name="url" select="." rdfs:label="Target URL"/>
    <xsl:param
        name="urlPrefix"
        select="''"
        rdfs:label="URL to prepend to target URL"/>

    <xsl:choose>
      <xsl:when test="starts-with($url, 'tag:')">
        <xsl:value-of select="$url"/>
      </xsl:when>

      <xsl:otherwise>
        <a href="{$urlPrefix}{$url}">
          <xsl:value-of select="$url"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      name="a:linkto-if-url"
      match="*|@*"
      mode="a:linkto-if-url"
      rdfs:label="Create link if value is an URL">
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
      <p>Create a link displaying the fragment. If the target URL
      does not have a fragment, display the complete URL.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:linkto-show-fragment"
      match="*|@*"
      mode="a:linkto-show-fragment"
      rdfs:label="Create &lt;a&gt;">
    <xsl:param
        name="urlPrefix"
        select="''"
        rdfs:label="URL to prepend to link targets"/>

    <a href="{$urlPrefix}{.}">
      <xsl:choose>
        <xsl:when test="contains(., '#')">
          <xsl:value-of select="substring-after(., '#')"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>If the xpointer is an ID or an element() or xpointer() routed
      at an ID, link to that ID; otherwise simply link to the
      document.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xi:include"
      mode="a:linkto"
      rdfs:label="Create link to XIncluded resource">
    <xsl:param
        name="urlPrefix"
        select="''"
        rdfs:label="URL to prepend to link targets"/>

    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="concat($urlPrefix, @href)"/>

        <xsl:variable name="id">
          <xsl:apply-templates
              select="@xpointer"
              mode="a:extract-id-from-xpointer"/>
        </xsl:variable>

        <xsl:if test="$id != ''">
          <xsl:value-of select="concat('#', $id)"/>
        </xsl:if>
      </xsl:attribute>

      <xsl:value-of select="@href"/>

      <xsl:if test="@xpointer">
        <xsl:value-of select="concat('#', @xpointer)"/>
      </xsl:if>
    </a>
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

      <xsl:apply-templates select="." mode="a:name"/>
    </h2>
  </xsl:template>

  <xsl:template match="*" mode="a:h3" rdfs:label="Create &lt;h3&gt; with id">
    <h3>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:name"/>
    </h3>
  </xsl:template>

  <xsl:template match="*" mode="a:h4" rdfs:label="Create &lt;h4&gt; with id">
    <h4>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:name"/>
    </h4>
  </xsl:template>

  <xsl:template match="*" mode="a:h5" rdfs:label="Create &lt;h5&gt; with id">
    <h5>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:name"/>
    </h5>
  </xsl:template>

  <xsl:template match="*" mode="a:h6" rdfs:label="Create &lt;h6&gt; with id">
    <h6>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:name"/>
    </h6>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>HTML attributes</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="*|@*"
      mode="a:title-attr"
      rdfs:label="Create title attribute from a:label">
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="a:label"/>
    </xsl:variable>

    <xsl:if test="$label != ''">
      <xsl:attribute name="title">
        <xsl:value-of select="$label"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Links to HTML elements</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="a:a" rdfs:label="Create &lt;a&gt;">
    <a>
      <xsl:attribute name="href">
        <xsl:text>#</xsl:text>
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title-attr"/>

      <xsl:apply-templates select="." mode="a:name"/>
    </a>
  </xsl:template>

  <xsl:template match="@*" mode="a:a" rdfs:label="Create &lt;a&gt;">
    <a>
      <xsl:attribute name="href">
        <xsl:text>#</xsl:text>
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title-attr"/>

      <xsl:apply-templates select="." mode="a:name"/>
    </a>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>More efficient implementation for <code>@xml:id</code> which
      is known to be an ID.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="@xml:id" mode="a:a" rdfs:label="Create &lt;a&gt;">
    <a href="#{.}">
      <xsl:apply-templates select="." mode="a:title-attr"/>

      <xsl:value-of select="."/>
    </a>
  </xsl:template>

  <xsl:template
      match="*|@*"
      mode="a:li-a"
      rdfs:label="Create &lt;li> containing call to a:a">
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
        select="normalize-space()"
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
        select="normalize-space()"
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

  <xsl:template
      match="*|@*"
      mode="a:li"
      rdfs:label="Create &lt;li> containing call to a:auto">
    <li>
      <xsl:apply-templates select="." mode="a:auto"/>
    </li>
  </xsl:template>

  <xsl:template
      match="rdfs:comment|@rdfs:comment"
      mode="a:li"
      rdfs:label="Create &lt;li> containing comment text">
    <li>
      <xsl:value-of select="."/>
    </li>
  </xsl:template>

  <xsl:template
      match="*|@*"
      mode="a:p"
      rdfs:label="Create &lt;p> containing call to a:auto">
    <p>
      <xsl:apply-templates select="." mode="a:auto"/>
    </p>
  </xsl:template>

  <xsl:template
      match="rdfs:comment|@rdfs:comment"
      mode="a:p"
      rdfs:label="Create &lt;p> containing comment text">
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template
      match="*|@*"
      mode="a:td"
      rdfs:label="Create &lt;td> containing call to a:auto">
    <td>
      <xsl:apply-templates select="." mode="a:auto"/>
    </td>
  </xsl:template>

  <xsl:template
      match="rdfs:comment|@rdfs:comment"
      mode="a:td"
      rdfs:label="Create &lt;td>">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>

  <xsl:template
      match="*|@*"
      mode="a:th"
      rdfs:label="Create &lt;th> containing local node name">
    <th>
      <xsl:call-template name="a:ucfirst-undash">
        <xsl:with-param name="text" select="local-name()"/>
      </xsl:call-template>
    </th>
  </xsl:template>

  <xsl:template
      match="dc:accessRights|@dc:accessRights"
      mode="a:th"
      rdfs:label="Create &lt;th> with fixed text">
    <th>Access rights</th>
  </xsl:template>

  <xsl:template
      match="dc:rightsHolder|@dc:rightsHolder"
      mode="a:th"
      rdfs:label="Create &lt;th> with fixed text">
    <th>Rights holder</th>
  </xsl:template>

  <xsl:template
      match="owl:versionInfo|@owl:versionInfo"
      mode="a:th"
      rdfs:label="Create &lt;th> with fixed text">
    <th>Version</th>
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

  <xsl:template
      name="a:bin2tds"
      match="*|@*"
      mode="a:bin2tds"
      rdfs:label="Create &lt;td>s from binary literal">
    <xsl:param name="value" select="." rdfs:label="Binary literal"/>
    <xsl:param name="content0" select="0" rdfs:label="Content to represent 0"/>
    <xsl:param name="content1" select="1" rdfs:label="Content to represent 1"/>

    <td>
      <xsl:choose>
        <xsl:when test="substring($value, 1, 1) = 1">
          <xsl:value-of select="$content1"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="$content0"/>
        </xsl:otherwise>
      </xsl:choose>
    </td>

    <xsl:if test="string-length($value) > 1">
      <xsl:call-template name="a:bin2tds">
        <xsl:with-param name="value" select="substring($value, 2)" />
        <xsl:with-param name="content0" select="$content0" />
        <xsl:with-param name="content1" select="$content1" />
      </xsl:call-template>
    </xsl:if>
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
                <xsl:text>created </xsl:text>
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
      match="@dc:rights|dc:rights"
      mode="a:auto"
      rdfs:label="Call a:linkto-if-url">
    <xsl:call-template name="a:linkto-if-url"/>
  </xsl:template>

  <xsl:template
      match="href|@href|schemaLocation|@schemaLocation|owl:sameAs|@owl:sameAs|rdfs:seeAlso|@rdfs:seeAlso"
      mode="a:auto"
      rdfs:label="Call a:linkto">
    <xsl:param
        name="urlPrefix"
        select="''"
        rdfs:label="URL to prepend to target URL"/>

    <xsl:call-template name="a:linkto">
      <xsl:with-param name="urlPrefix" select="$urlPrefix"/>
    </xsl:call-template>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Based on the assumption that rdf:type often links to a
      fragment in an XSD, as suggested by <a
      href="https://www.w3.org/TR/swbp-xsch-datatypes">XML Schema
      Datatypes in RDF and OWL</a>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="@rdf:type|rdf:type"
      mode="a:auto"
      rdfs:label="Call a:linkto-show-fragment">
    <xsl:param
        name="urlPrefix"
        select="''"
        rdfs:label="URL to prepend to link targets"/>

    <xsl:call-template name="a:linkto-show-fragment">
      <xsl:with-param name="urlPrefix" select="$urlPrefix"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template
      match="@rdfs:comment|rdfs:comment"
      mode="a:auto"
      rdfs:label="Create title attribute">
    <xsl:attribute name="title">
      <xsl:value-of select="normalize-space()"/>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
