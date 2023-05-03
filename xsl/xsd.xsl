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
    xmlns:axsd="tag:rv1971@web.de,2021:alcamo-xsl:xsd#"
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    exclude-result-prefixes="a dc axsd rdfs sh xh xsd"
    xml:lang="en"
    dc:identifier="xsd"
    dc:title="Format an XSD for human readers"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-21"
    dc:modified="2023-05-02">
  <xsl:import href="annotation.xsl"/>
  <xsl:import href="html-document.xsl"/>
  <xsl:import href="syntaxhighlight-xml.xsl"/>
  <xsl:import href="xsd-access.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>This stylesheet is used to format XSDs for human readers.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Embedded data</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation>
      <p>Map element IDs to labels.</p>

      <p>The list is divided into those IDs that may appear at top
      level and those which cannot. Each of the two sublists is
      ordered by <code>id</code>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <axsd:elements rdfs:label="XSD elements">
    <!-- elements that may appear at top level -->

    <axsd:element id="abstractComplexType">Abstract complex type</axsd:element>
    <axsd:element id="attribute">Attribute</axsd:element>
    <axsd:element id="attributeGroup">Attribute group</axsd:element>
    <axsd:element id="complexType">Complex type</axsd:element>
    <axsd:element id="element">Element</axsd:element>
    <axsd:element id="group">Group</axsd:element>
    <axsd:element id="import">Import</axsd:element>
    <axsd:element id="include">Include</axsd:element>
    <axsd:element id="simpleType">Simple type</axsd:element>

    <!-- elements that cannot appear at top level -->

    <axsd:element id="all">All</axsd:element>
    <axsd:element id="anyAttribute">Any attribute</axsd:element>
    <axsd:element id="choice">Choice</axsd:element>
    <axsd:element id="complexContent">Complex content</axsd:element>
    <axsd:element id="extension">Extension</axsd:element>
    <axsd:element id="enumeration">Enumeration</axsd:element>
    <axsd:element id="field">Field</axsd:element>
    <axsd:element id="keyref">Keyref</axsd:element>
    <axsd:element id="key">Key</axsd:element>
    <axsd:element id="length">length</axsd:element>
    <axsd:element id="list">List</axsd:element>
    <axsd:element id="localAttribute"></axsd:element>
    <axsd:element id="maxInclusive">Max inclusive</axsd:element>
    <axsd:element id="maxLength">Max length</axsd:element>
    <axsd:element id="minInclusive">Min inclusive</axsd:element>
    <axsd:element id="minLength">Min length</axsd:element>
    <axsd:element id="pattern">Pattern</axsd:element>
    <axsd:element id="restriction">Restriction</axsd:element>
    <axsd:element id="selector">Selector</axsd:element>
    <axsd:element id="sequence">Sequence</axsd:element>
    <axsd:element id="simpleContent">Simple content</axsd:element>
    <axsd:element id="union">Union</axsd:element>
    <axsd:element id="unique">Unique</axsd:element>
  </axsd:elements>

  <xsl:key
      name="axsd:elements"
      match="/*/axsd:elements/axsd:element"
      use="@id"/>

  <xsl:variable
      name="a:xsdXslDoc"
      select="document('')"
      rdfs:label="This document"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="a:cssList"
      select="concat($a:xslDirUrl, 'css/alcamo.css', ' ', $a:xslDirUrl, 'css/syntaxhighlight.css', ' ', $a:xslDirUrl, 'css/xsd.css')"/>

  <xsl:param name="sh:maxInlineAttrs" select="3"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Links</h2>

      <p>The templates with mode <code>axsd:linkto</code> create
      internal links if the target does not have a namespace prefix
      and is present in the current document. They may be overridden by
      more sophisticated mechanisms linking to other documents.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="@base|@itemType|@type"
      mode="axsd:linkto"
      rdfs:label="Create &lt;code&gt; or &lt;a&gt;">
    <xsl:choose>
      <xsl:when test="contains(., ':') or not(key('axsd:types', .))">
        <code>
          <xsl:value-of select="."/>
        </code>
      </xsl:when>

      <xsl:otherwise>
        <a href="#type-{.}" class="code">
          <xsl:value-of select="."/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      match="@ref"
      mode="axsd:linkto"
      rdfs:label="Create &lt;code&gt; or &lt;a&gt;">
    <xsl:choose>
      <xsl:when
          test="contains(., ':') or not(key(concat('axsd:', local-name(..), 's'), .))">
        <code>
          <xsl:value-of select="."/>
        </code>
      </xsl:when>

      <xsl:otherwise>
        <a href="#{local-name(..)}-{.}" class="code">
          <xsl:value-of select="."/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      match="xsd:element/@ref"
      mode="axsd:linkto"
      rdfs:label="Create &lt;code&gt; or &lt;a&gt;">
    <xsl:choose>
      <xsl:when test="contains(., ':') or not(key('axsd:elements', .))">
        <code>
          <xsl:value-of select="concat('&lt;', ., '&gt;')"/>
        </code>
      </xsl:when>

      <xsl:otherwise>
        <a href="#element-{.}" class="code">
          <xsl:value-of select="concat('&lt;', ., '&gt;')"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Headings</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="@*" mode="axsd:title-suffix">
    <xsl:text> </xsl:text>

    <code>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>

  <xsl:template match="@base" mode="axsd:title-suffix">
    <xsl:text> of </xsl:text>

    <xsl:apply-templates select="." mode="axsd:linkto"/>
  </xsl:template>

  <xsl:template match="@default|@fixed" mode="axsd:title-suffix">
    <xsl:value-of select="concat(', ', name(), ' ')"/>

    <code>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>

  <xsl:template match="@itemType|@type" mode="axsd:title-suffix">
    <xsl:text> of type </xsl:text>

    <xsl:apply-templates select="." mode="axsd:linkto"/>
  </xsl:template>

  <xsl:template match="@name" mode="axsd:title-suffix">
    <code>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>

  <xsl:template match="xsd:element/@name" mode="axsd:title-suffix">
    <code>
      <xsl:value-of select="concat('&lt;', ., '&gt;')"/>
    </code>
  </xsl:template>

  <xsl:template match="@ref" mode="axsd:title-suffix">
    <xsl:apply-templates select="." mode="axsd:linkto"/>
  </xsl:template>

  <xsl:template match="@use" mode="axsd:title-suffix">
    <xsl:value-of select="concat(', ', .)"/>
  </xsl:template>

  <xsl:template match="xsd:*" mode="a:title">
    <xsl:choose>
      <xsl:when test="@abstract = 'true'">
        <xsl:for-each select="$a:xsdXslDoc">
          <xsl:value-of select="key('axsd:elements', 'abstractComplexType')"/>
        </xsl:for-each>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="localName" select="local-name()"/>

        <xsl:for-each select="$a:xsdXslDoc">
          <xsl:value-of select="key('axsd:elements', $localName)"/>
        </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>

    <xsl:text> </xsl:text>

    <xsl:apply-templates select="@base|@name|@ref" mode="axsd:title-suffix"/>

    <xsl:apply-templates
        select="@itemType|@memberTypes|@type"
        mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@use" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@default|@fixed" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@value" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@xpath" mode="axsd:title-suffix"/>

    <xsl:call-template name="a:occurrence"/>
  </xsl:template>

  <xsl:template match="xsd:attribute[not(parent::xsd:schema)]" mode="a:title">
    <xsl:apply-templates select="@name|@ref" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@type" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@use" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@default|@fixed" mode="axsd:title-suffix"/>
  </xsl:template>

  <xsl:template match="xsd:element[not(parent::xsd:schema)]" mode="a:title">
    <xsl:apply-templates select="@name|@ref" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@type" mode="axsd:title-suffix"/>

    <xsl:call-template name="a:occurrence"/>
  </xsl:template>

  <xsl:template match="*" mode="axsd:heading">
    <p>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:if test="@id">
        <a id="{@id}"/>
      </xsl:if>

      <xsl:apply-templates select="." mode="a:title"/>
    </p>
  </xsl:template>

  <xsl:template match="/*/*" mode="axsd:heading">
    <h3>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:if test="@id">
        <a id="{@id}"/>
      </xsl:if>

      <xsl:apply-templates select="." mode="a:title"/>
    </h3>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Document body</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="xsd:annotation" mode="axsd:main"/>

      <xsl:if test="xsd:attribute|xsd:attributeGroup">
        <section>
          <xsl:if test="not(self::xsd:attributeGroup)">
            <p>Attributes</p>
          </xsl:if>

          <ul class="xsd-attributes">
            <xsl:apply-templates
                select="xsd:attribute|xsd:attributeGroup"
                mode="axsd:main"/>
          </ul>
        </section>
      </xsl:if>

      <xsl:apply-templates
          select="*[not(self::xsd:annotation)][not(self::xsd:attribute)][not(self::xsd:attributeGroup)]"
          mode="axsd:main"/>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:annotation|xsd:simpleType[not(@*)]"
      mode="axsd:main">
    <xsl:apply-templates mode="axsd:main"/>
  </xsl:template>

  <xsl:template match="xsd:documentation" mode="axsd:main">
    <div class="xsd-documentation">
      <xsl:apply-templates mode="a:copy"/>
    </div>
  </xsl:template>

  <xsl:template match="xsd:appinfo" mode="axsd:main">
    <section class="xsd-appinfo">
      <pre>
        <xsl:apply-templates mode="sh:xml"/>
      </pre>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:attribute[not(parent::xsd:schema)]|xsd:attributeGroup[not(parent::xsd:schema)]|xsd:element[not(parent::xsd:schema)]|xsd:group[not(parent::xsd:schema)]"
      mode="axsd:main">
    <li>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates mode="axsd:main"/>
    </li>
  </xsl:template>

  <xsl:template match="xsd:choice|xsd:sequence" mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <ul class="xsd-{local-name()}">
        <xsl:apply-templates mode="axsd:main"/>
      </ul>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:choice/xsd:choice|xsd:choice/xsd:sequence|xsd:sequence/xsd:choice|xsd:sequence/xsd:sequence"
      mode="axsd:main">
    <li>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <ul class="xsd-{local-name()}">
        <xsl:apply-templates mode="axsd:main"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template
      match="xsd:import|xsd:include"
      mode="axsd:main"
      rdfs:label="Ignore imports and includes except the first ones"/>

  <xsl:template match="xsd:import[1]" mode="axsd:main">
    <section>
      <h2 id="imports">Imports</h2>

      <table>
        <thead>
          <tr>
            <th>Namespace</th>
            <th>Location</th>
          </tr>
        </thead>

        <tbody>
          <xsl:for-each select="/*/xsd:import">
            <tr>
              <td class="code">
                <xsl:value-of select="@namespace"/>
              </td>

              <td>
                <a href="{@schemaLocation}">
                  <xsl:value-of select="@schemaLocation"/>
                </a>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </section>
  </xsl:template>

  <xsl:template match="xsd:include[1]" mode="axsd:main">
    <section>
      <h2 id="includes">Includes</h2>

      <ul>
        <xsl:for-each select="/*/xsd:include">
          <li>
            <a href="{@schemaLocation}">
              <xsl:value-of select="@schemaLocation"/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </section>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Document skeleton</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xh:h2"
      mode="axsd:toc-li"
      rdfs:label="Create &lt;li&gt; for the TOC">
    <li>
      <p>
        <xsl:apply-templates select="." mode="a:a"/>
      </p>

      <!-- Get the set of all following top-level elements and
           documentation h3 elements. -->

      <xsl:variable
          name="topf"
          select="following::*[parent::xsd:schema][local-name() != 'import'][local-name() != 'include']"/>

      <!-- Get the next <xsd:annotation> element containing an <h2>
           element, if any. -->

      <xsl:variable
          name="xsdf"
          select="following::xsd:annotation[xsd:documentation/xh:h2][1]"/>

      <xsl:variable name="subToc">
        <xsl:choose>
          <xsl:when test="$xsdf">
            <xsl:for-each
                select="$xsdf/preceding::*[count($topf | .) = count($topf)]|following-sibling::xh:h3">
              <li>
                <xsl:apply-templates select="." mode="a:a"/>
              </li>
            </xsl:for-each>
          </xsl:when>

          <xsl:otherwise>
            <xsl:for-each select="$topf|following-sibling::xh:h3">
              <li>
                <xsl:apply-templates select="." mode="a:a"/>
              </li>
            </xsl:for-each>
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

  <xsl:template
      match="xsd:import[1]"
      mode="axsd:toc-li"
      rdfs:label="Create &lt;li&gt; for the TOC">
    <li>
      <p>
        <a href="#imports">Imports</a>
      </p>
    </li>
  </xsl:template>

  <xsl:template
      match="xsd:include[1]"
      mode="axsd:toc-li"
      rdfs:label="Create &lt;li&gt; for the TOC">
    <li>
      <p>
        <a href="#includes">Includes</a>
      </p>
    </li>
  </xsl:template>

  <xsl:template name="a:toc" rdfs:label="Create TOC &lt;ul&gt;">
    <ul id="toc">
      <xsl:apply-templates
          select="/*/xsd:annotation/xsd:documentation/xh:h2|/*/xsd:import[1]|/*/xsd:include[1]"
          mode="axsd:toc-li"/>

      <li>
        <p>
          <a href="#xsd-references">XSD references</a>
        </p>
      </li>
    </ul>
  </xsl:template>

  <xsl:template
      name="axsd:references"
      rdfs:label="Create references &lt;h2&gt; and  &lt;ul&gt;">
    <h2 id="xsd-references">XSD references</h2>

    <ul>
      <li><a href="https://www.w3.org/TR/xmlschema-0/">XML Schema Part 0: Primer</a></li>
      <li><a href="https://www.w3.org/TR/xmlschema-1/">XML Schema Part 1: Structures</a></li>
      <li><a href="https://www.w3.org/TR/xmlschema-2/">XML Schema Part 2: Datatypes</a></li>
    </ul>
  </xsl:template>

  <xsl:template name="a:page-main">
    <xsl:apply-templates select="/*/*" mode="axsd:main"/>

    <xsl:call-template name="axsd:references"/>
  </xsl:template>
</xsl:stylesheet>
