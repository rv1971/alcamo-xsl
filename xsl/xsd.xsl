<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
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
    dc:modified="2023-05-07">
  <xsl:import href="annotation.xsl"/>
  <xsl:import href="html-document.xsl"/>
  <xsl:import href="syntaxhighlight-xml.xsl"/>
  <xsl:import href="xsd-access.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>This stylesheet is used to format XSDs for human readers.</p>

      <p>Each top-level element other than documentation gets a level
      3 heading. Level 2 and level 3 headings in top-level
      <code>&lt;xsd:annotation></code> elements containing
      <code>&lt;xsd:documentation></code>, together with the generated
      level 3 headings, are used to create a table of contents.</p>
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
    <axsd:element id="length">Length</axsd:element>
    <axsd:element id="list">List</axsd:element>
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
      name="axsd:minAttrOverviewSize"
      select="3"
      rdfs:label="Minimum number of attributes for an overview table"/>

  <xsl:param
      name="axsd:minEnumOverviewSize"
      select="3"
      rdfs:label="Minimum number of enumerators for an overview table"/>

  <xsl:param
      name="a:cssList"
      select="concat($a:xslDirUrl, 'css/alcamo.css', ' ', $a:xslDirUrl, 'css/syntaxhighlight.css', ' ', $a:xslDirUrl, 'css/xsd.css')"/>

  <xsl:param name="sh:maxInlineAttrs" select="3"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Variables</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:variable name="axsd:elementsWithId" select="//xsd:*[@id]"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Links</h2>

      <p>The templates with mode <code>a:linkto</code> create internal
      links if the target does not have a namespace prefix and is
      present in the current document. If the target does not have a
      namespace prefix and is not present in the current document,
      they attempt to link to an immediately included document.</p>

      <p>These templates may be overridden by mechanisms linking to
      other documents in a more sophisticated way.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="@base|@itemType|@type"
      mode="a:linkto"
      rdfs:label="Create &lt;code&gt; or &lt;a&gt;">
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="contains(., ':')">
          <code>
            <xsl:value-of select="."/>
          </code>
        </xsl:when>

        <xsl:when test="key('axsd:types', .)">
          <a href="#type-{.}" class="code">
            <xsl:value-of select="."/>
          </a>
        </xsl:when>

        <xsl:otherwise>
          <xsl:variable name="name" select="."/>

          <xsl:for-each select="/*/xsd:include/@schemaLocation">
            <xsl:variable name="schemaLocation" select="."/>

            <xsl:for-each select="document(.)">
              <xsl:variable
                  name="definition"
                  select="key('axsd:types', $name)"/>

              <xsl:if test="$definition">
                <a href="{$schemaLocation}#type-{$name}" class="code">
                  <xsl:value-of select="$name"/>
                </a>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$link != ''">
        <xsl:copy-of select="$link"/>
      </xsl:when>

      <xsl:otherwise>
        <code>
          <xsl:value-of select="."/>
        </code>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      match="@ref"
      mode="a:linkto"
      rdfs:label="Create &lt;code&gt; or &lt;a&gt;">
    <xsl:variable name="keyName" select="concat('axsd:', local-name(..), 's')"/>

    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="contains(., ':')">
          <code>
            <xsl:value-of select="."/>
          </code>
        </xsl:when>

        <xsl:when test="key($keyName, .)">
          <a href="#{local-name(..)}-{.}" class="code">
            <xsl:value-of select="."/>
          </a>
        </xsl:when>

        <xsl:otherwise>
          <xsl:variable name="ref" select="."/>

          <xsl:for-each select="/*/xsd:include/@schemaLocation">
            <xsl:variable name="schemaLocation" select="."/>

            <xsl:for-each select="document(.)">
              <xsl:variable
                  name="definition"
                  select="key($keyName, $ref)"/>

              <xsl:if test="$definition">
                <a
                    href="{$schemaLocation}#{local-name($ref/..)}-{$ref}"
                    class="code">
                  <xsl:value-of select="$ref"/>
                </a>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$link != ''">
        <xsl:copy-of select="$link"/>
      </xsl:when>

      <xsl:otherwise>
        <code>
          <xsl:value-of select="."/>
        </code>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      match="xsd:element/@ref"
      mode="a:linkto"
      rdfs:label="Create &lt;code&gt; or &lt;a&gt;">
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="contains(., ':')">
          <code>
            <xsl:value-of select="concat('&lt;', ., '&gt;')"/>
          </code>
        </xsl:when>

        <xsl:when test="key('axsd:elements', .)">
          <a href="#element-{.}" class="code">
            <xsl:value-of select="concat('&lt;', ., '&gt;')"/>
          </a>
        </xsl:when>

        <xsl:otherwise>
          <xsl:variable name="ref" select="."/>

          <xsl:for-each select="/*/xsd:include/@schemaLocation">
            <xsl:variable name="schemaLocation" select="."/>

            <xsl:for-each select="document(.)">
              <xsl:variable
                  name="definition"
                  select="key('axsd:elements', $ref)"/>

              <xsl:if test="$definition">
                <a href="{$schemaLocation}#element-{$ref}" class="code">
                  <xsl:value-of select="$ref"/>
                </a>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$link != ''">
        <xsl:copy-of select="$link"/>
      </xsl:when>

      <xsl:otherwise>
        <code>
          <xsl:value-of select="concat('&lt;', ., '&gt;')"/>
        </code>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Heading text</h2>
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

    <xsl:apply-templates select="." mode="a:linkto"/>
  </xsl:template>

  <xsl:template match="@default|@fixed" mode="axsd:title-suffix">
    <xsl:value-of select="concat(', ', name(), ' ')"/>

    <code>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>

  <xsl:template match="@itemType|@type" mode="axsd:title-suffix">
    <xsl:text> of type </xsl:text>

    <xsl:apply-templates select="." mode="a:linkto"/>
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

  <xsl:template match="@namespace" mode="axsd:title-suffix">
    <xsl:text> of namespace </xsl:text>

    <code>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>

  <xsl:template match="@ref" mode="axsd:title-suffix">
    <xsl:apply-templates select="." mode="a:linkto"/>
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
        select="@itemType|@memberTypes|@namespace|@type"
        mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@use" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@default|@fixed" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@value" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@xpath" mode="axsd:title-suffix"/>

    <xsl:call-template name="a:occurrence"/>
  </xsl:template>

  <xsl:template match="xsd:attribute[count(..|/*) = 2]" mode="a:title">
    <xsl:apply-templates select="@name|@ref" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@type" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@use" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@default|@fixed" mode="axsd:title-suffix"/>
  </xsl:template>

  <xsl:template match="xsd:element[count(..|/*) = 2]" mode="a:title">
    <xsl:apply-templates select="@name|@ref" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@type" mode="axsd:title-suffix"/>

    <xsl:call-template name="a:occurrence"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Headings</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="axsd:heading">
    <p>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>

      <xsl:if test="@rdfs:label">
        <xsl:text>&#xa0;– </xsl:text>
        <xsl:value-of select="@rdfs:label"/>
      </xsl:if>
    </p>
  </xsl:template>

  <xsl:template match="/*/*" mode="axsd:heading">
    <h3>
      <xsl:attribute name="id">
        <xsl:apply-templates select="." mode="a:id"/>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="a:title"/>

      <xsl:if test="@rdfs:label">
        <xsl:text>&#xa0;– </xsl:text>
        <xsl:value-of select="@rdfs:label"/>
      </xsl:if>
    </h3>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Generic XSD attributes</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="@*" mode="axsd:generic-attrs"/>

  <xsl:template match="@*[namespace-uri()]" mode="axsd:generic-attrs">
    <xsl:apply-templates select="." mode="a:tr"/>
  </xsl:template>

  <xsl:template match="@rdfs:label" mode="axsd:generic-attrs" priority="1.0"/>

  <xsl:template match="@id" mode="axsd:generic-attrs">
    <tr id="{.}">
      <th>id</th>

      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="xsd:*" mode="axsd:generic-attrs">
    <xsl:variable name="content">
      <xsl:apply-templates select="@*" mode="axsd:generic-attrs"/>
    </xsl:variable>

    <xsl:if test="$content != ''">
      <table class="xsd-generic-attrs">
        <tbody>
          <xsl:copy-of select="$content"/>
        </tbody>
      </table>
    </xsl:if>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Overviews</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="xsd:*" mode="axsd:attr-overview">
    <table class="xsd-attr-overview">
      <thead>
        <tr>
          <th>Name</th>

          <xsl:choose>
            <xsl:when test="xsd:anyAttribute">
              <th>Type&#xa0;/ namespace</th>
              <th>Use&#xa0;/ process</th>
            </xsl:when>

            <xsl:otherwise>
              <th>Type</th>
              <th>Use</th>
            </xsl:otherwise>
          </xsl:choose>

          <th>Label</th>
        </tr>
      </thead>

      <tbody>
        <xsl:for-each select="xsd:attribute">
          <tr>
            <td>
              <a class="code">
                <xsl:attribute name="href">
                  <xsl:text>#</xsl:text>
                  <xsl:apply-templates select="." mode="a:id"/>
                </xsl:attribute>

                <xsl:value-of select="@name|@ref"/>
              </a>
            </td>

            <td>
              <xsl:apply-templates select="@type" mode="a:linkto"/>
            </td>

            <td>
              <xsl:choose>
                <xsl:when test="@use">
                  <xsl:value-of select="@use"/>
                </xsl:when>

                <xsl:otherwise>optional</xsl:otherwise>
              </xsl:choose>
            </td>

            <td>
              <xsl:value-of select="@rdfs:label"/>
            </td>
          </tr>
        </xsl:for-each>

        <xsl:for-each select="xsd:anyAttribute">
          <tr>
            <td>Any</td>
            <td>
              <xsl:if test="@namespace">
                <code>
                  <xsl:value-of select="@namespace"/>
                </code>
              </xsl:if>
            </td>

            <td>
              <xsl:choose>
                <xsl:when test="@processContents">
                  <xsl:value-of select="@processContents"/>
                </xsl:when>

                <xsl:otherwise>strict</xsl:otherwise>
              </xsl:choose>
            </td>

            <td>
              <xsl:value-of select="@rdfs:label"/>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="xsd:*" mode="axsd:enum-overview">
    <table class="xsd-enum-overview">
      <thead>
        <tr>
          <th>Value</th>
          <th>Label</th>

          <xsl:if test="xsd:enumeration[@owl:sameAs]">
            <th>Same as</th>
          </xsl:if>
        </tr>
      </thead>

      <tbody>
        <xsl:for-each select="xsd:enumeration">
          <tr>
            <td>
              <a class="code">
                <xsl:attribute name="href">
                  <xsl:text>#</xsl:text>
                  <xsl:apply-templates select="." mode="a:id"/>
                </xsl:attribute>

                <xsl:value-of select="@value"/>
              </a>
            </td>

            <td>
              <xsl:value-of select="@rdfs:label"/>
            </td>

            <xsl:if test="../xsd:enumeration[@owl:sameAs]">
              <td>
                <xsl:if test="@owl:sameAs">
                  <a href="{@owl:sameAs}">
                    <xsl:value-of select="@owl:sameAs"/>
                  </a>
                </xsl:if>
              </td>
            </xsl:if>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="/*/xsd:*" mode="axsd:restrictions-extensions">
    <xsl:variable
        name="restrictions"
        select="key('axsd:namedRestrictions', @name)"/>

    <xsl:if test="$restrictions">
      <section>
        <p>Restrictions</p>

        <ul class="code">
          <xsl:for-each select="$restrictions">
            <li>
              <xsl:apply-templates select="." mode="a:a"/>
            </li>
          </xsl:for-each>
        </ul>
      </section>
    </xsl:if>

    <xsl:variable
        name="extensions"
        select="key('axsd:namedExtensions', @name)"/>

    <xsl:if test="$extensions">
      <section>
        <p>Extensions</p>

        <ul class="code">
          <xsl:for-each select="$extensions">
            <li>
              <xsl:apply-templates select="." mode="a:a"/>
            </li>
          </xsl:for-each>
        </ul>
      </section>
    </xsl:if>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Document body</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

      <xsl:apply-templates mode="axsd:main"/>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:attributeGroup|xsd:extension|xsd:restriction"
      mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

      <xsl:apply-templates select="xsd:annotation" mode="axsd:main"/>

      <xsl:if test="xsd:attribute|xsd:attributeGroup">
        <section>
          <xsl:if test="not(self::xsd:attributeGroup)">
            <p>Attributes</p>
          </xsl:if>

          <xsl:if test="count(xsd:attribute) &gt;= $axsd:minAttrOverviewSize">
            <xsl:apply-templates select="." mode="axsd:attr-overview"/>
          </xsl:if>

          <ul class="xsd-attributes">
            <xsl:apply-templates
                select="xsd:attribute|xsd:attributeGroup|xsd:anyAttribute"
                mode="axsd:main"/>
          </ul>
        </section>
      </xsl:if>

      <xsl:apply-templates
          select="*[not(self::xsd:annotation)][not(self::xsd:attribute)][not(self::xsd:attributeGroup)][not(self::xsd:anyAttribute)]"
          mode="axsd:main"/>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:complexType"
      mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

      <xsl:apply-templates select="xsd:annotation" mode="axsd:main"/>

      <xsl:if test="xsd:attribute|xsd:attributeGroup">
        <section>
          <xsl:if test="not(self::xsd:attributeGroup)">
            <p>Attributes</p>
          </xsl:if>

          <xsl:if test="count(xsd:attribute) &gt;= $axsd:minAttrOverviewSize">
            <xsl:apply-templates select="." mode="axsd:attr-overview"/>
          </xsl:if>

          <ul class="xsd-attributes">
            <xsl:apply-templates
                select="xsd:attribute|xsd:attributeGroup|xsd:anyAttribute"
                mode="axsd:main"/>
          </ul>
        </section>
      </xsl:if>

      <xsl:apply-templates
          select="*[not(self::xsd:annotation)][not(self::xsd:attribute)][not(self::xsd:attributeGroup)][not(self::xsd:anyAttribute)]"
          mode="axsd:main"/>

      <xsl:apply-templates select="." mode="axsd:restrictions-extensions"/>
    </section>
  </xsl:template>

  <xsl:template match="/*/xsd:simpleType" mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

      <xsl:apply-templates mode="axsd:main"/>

      <xsl:apply-templates select="." mode="axsd:restrictions-extensions"/>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:simpleContent/xsd:restriction|xsd:simpleType/xsd:restriction"
      mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

      <xsl:apply-templates select="xsd:annotation" mode="axsd:main"/>

      <xsl:if test="count(xsd:enumeration) &gt;= $axsd:minEnumOverviewSize">
        <xsl:apply-templates select="." mode="axsd:enum-overview"/>
      </xsl:if>

      <xsl:apply-templates
          select="*[not(self::xsd:annotation)]"
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

  <xsl:template match="/*/xsd:annotation/xsd:documentation" mode="axsd:main">
    <xsl:apply-templates mode="a:copy"/>
  </xsl:template>

  <xsl:template match="xsd:appinfo" mode="axsd:main">
    <section class="xsd-appinfo">
      <pre>
        <xsl:apply-templates mode="sh:xml"/>
      </pre>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:attribute[count(..|/*) = 2]
             |xsd:attributeGroup[count(..|/*) = 2]
             |xsd:anyAttribute[count(..|/*) = 2]
             |xsd:element[count(..|/*) = 2]
             |xsd:group[count(..|/*) = 2]"
      mode="axsd:main">
    <li>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

      <xsl:apply-templates mode="axsd:main"/>
    </li>
  </xsl:template>

  <xsl:template match="xsd:choice|xsd:sequence" mode="axsd:main">
    <section>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

      <ul class="xsd-{local-name()}">
        <xsl:apply-templates mode="axsd:main"/>
      </ul>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:choice/xsd:choice
             |xsd:choice/xsd:sequence
             |xsd:sequence/xsd:choice
             |xsd:sequence/xsd:sequence"
      mode="axsd:main">
    <li>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <xsl:apply-templates select="." mode="axsd:generic-attrs"/>

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

      <xsl:if test="$subToc != ''">
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
          <a href="#appendix">Appendix</a>
        </p>
        <ul>
          <li>
            <p>
              <a href="#elements-with-id">Elements with ID</a>
            </p>
          </li>

          <li>
            <p>
              <a href="#xsd-references">XSD references</a>
            </p>
          </li>
        </ul>
      </li>
    </ul>
  </xsl:template>

  <xsl:template
      name="axsd:elements-with-id"
      rdfs:label="Create &lt;h3&gt; and &lt;table&gt; for elements with ID">
    <h3 id="elements-with-id">Elements with ID</h3>

    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Tag name</th>
          <th>Label</th>
        </tr>
      </thead>

      <tbody>
        <xsl:for-each select="$axsd:elementsWithId">
          <tr>
            <td class="code">
              <a href="#{@id}">
                <xsl:value-of select="@id"/>
              </a>
            </td>

            <td class="code">
              <xsl:value-of select="local-name()"/>
            </td>

            <td>
              <xsl:value-of select="@rdfs:label"/>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template
      name="axsd:references"
      rdfs:label="Create references &lt;h3&gt; and  &lt;ul&gt;">
    <h3 id="xsd-references">XSD references</h3>

    <ul>
      <li><a href="https://www.w3.org/TR/xmlschema-0/">XML Schema Part 0: Primer</a></li>
      <li><a href="https://www.w3.org/TR/xmlschema-1/">XML Schema Part 1: Structures</a></li>
      <li><a href="https://www.w3.org/TR/xmlschema-2/">XML Schema Part 2: Datatypes</a></li>
    </ul>
  </xsl:template>

  <xsl:template
      name="axsd:appendix"
      rdfs:label="Create appendix &lt;h2&gt; and call further templates">
    <h2 id="appendix">Appendix</h2>

    <xsl:if test="$axsd:elementsWithId">
      <xsl:call-template name="axsd:elements-with-id"/>
    </xsl:if>

    <xsl:call-template name="axsd:references"/>
  </xsl:template>

  <xsl:template name="a:page-main">
    <xsl:apply-templates select="/*/*" mode="axsd:main"/>

    <xsl:call-template name="axsd:appendix"/>
  </xsl:template>
</xsl:stylesheet>
