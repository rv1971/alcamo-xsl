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
    dc:modified="2023-04-25">
  <xsl:import href="annotation.xsl"/>
  <xsl:import href="html-document.xsl"/>
  <xsl:import href="syntaxhighlight-xml.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Embedded data</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation>
      <p>Maps element IDs to labels and optionally to uid prefixes
      used to generate <code>id</code> attributes in the result
      tree. If no uid prefix is given, the <code>id</code> is used. In
      most cases, the <code>id</code> is identical to the local name
      of the XSD element, but there are exceptions such as
      <code>abstractComplexType</code>.</p>

      <p>The list is divided into those IDs that may appear at top
      level and those which cannot. Each of the two sublists is
      ordered by <code>id</code>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <axsd:elements rdfs:label="XSD elements">
    <!-- elements that may appear at top level -->

    <axsd:element
        id="abstractComplexType"
        uidPrefix="type"
        rdfs:label="Abstract complex type"/>
    <axsd:element
        id="attribute"
        rdfs:label="Attribute"/>
    <axsd:element
        id="attributeGroup"
        rdfs:label="Attribute group"/>
    <axsd:element
        id="complexType"
        uidPrefix="type"
        rdfs:label="Complex type"/>
    <axsd:element
        id="element"
        rdfs:label="Element"/>
    <axsd:element
        id="group"
        rdfs:label="Group"/>
    <axsd:element
        id="import"
        rdfs:label="Import"/>
    <axsd:element
        id="include"
        rdfs:label="Include"/>
    <axsd:element
        id="simpleType"
        uidPrefix="type"
        rdfs:label="Simple type"/>

    <!-- elements that cannot appear at top level -->

    <axsd:element
        id="all"
        rdfs:label="All"/>
    <axsd:element
        id="anyAttribute"
        rdfs:label="Any attribute"/>
    <axsd:element
        id="choice"
        rdfs:label="Choice"/>
    <axsd:element
        id="complexContent"
        rdfs:label="Complex content"/>
    <axsd:element
        id="extension"
        rdfs:label="Extension"/>
    <axsd:element
        id="enumeration"
        rdfs:label="Enumeration"/>
    <axsd:element
        id="field"
        rdfs:label="Field"/>
    <axsd:element
        id="keyref"
        rdfs:label="Keyref"/>
    <axsd:element
        id="key"
        rdfs:label="Key"/>
    <axsd:element
        id="length"
        rdfs:label="length"/>
    <axsd:element
        id="list"
        rdfs:label="List"/>
    <axsd:element
        id="localAttribute"
        rdfs:label=""/>
    <axsd:element
        id="maxInclusive"
        rdfs:label="Max inclusive"/>
    <axsd:element
        id="maxLength"
        rdfs:label="Max length"/>
    <axsd:element
        id="minInclusive"
        rdfs:label="Min inclusive"/>
    <axsd:element
        id="minLength"
        rdfs:label="Min length"/>
    <axsd:element
        id="pattern"
        rdfs:label="Pattern"/>
    <axsd:element
        id="restriction"
        rdfs:label="Restriction"/>
    <axsd:element
        id="selector"
        rdfs:label="Selector"/>
    <axsd:element
        id="sequence"
        rdfs:label="Sequence"/>
    <axsd:element
        id="simpleContent"
        rdfs:label="Simple content"/>
    <axsd:element
        id="union"
        rdfs:label="Union"/>
    <axsd:element
        id="unique"
        rdfs:label="Unique"/>
  </axsd:elements>

  <xsl:key
      name="axsd:elements"
      match="/*/axsd:elements/axsd:element"
      use="@id"/>

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
      <h2>Keys</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:key
      name="axsd:attributes"
      match="/*/xsd:attribute"
      use="@name"
      rdfs:label="Attributes declared in the current document"/>

  <xsl:key
      name="axsd:attributeGroups"
      match="/*/xsd:attributeGroup"
      use="@name"
      rdfs:label="Attribute groups declared in the current document"/>

  <xsl:key
      name="axsd:elements"
      match="/*/xsd:element"
      use="@name"
      rdfs:label="Elements declared in the current document"/>

  <xsl:key
      name="axsd:groups"
      match="/*/xsd:group"
      use="@name"
      rdfs:label="Groups declared in the current document"/>

  <xsl:key
      name="axsd:types"
      match="/*/xsd:simpleType|/*/xsd:complexType"
      use="@name"
      rdfs:label="Named types defined in the current document"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Links</h2>

      <p>The templates with mode <code>axsd:linkto</code> create
      internal links if the target does not have a namespace prefix
      and is present in the current document. They may be replaced by
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

  <xsl:template
      match="/*/xsd:*[@name]"
      mode="a:id"
      rdfs:label="Create text">
    <xsl:variable name="element" select="."/>

    <xsl:for-each select="document('')">
      <xsl:variable
          name="elementData"
          select="key('axsd:elements', local-name($element))"/>

      <xsl:choose>
        <xsl:when test="$elementData/@uidPrefix">
          <xsl:value-of select="$elementData/@uidPrefix"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="local-name($element)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <xsl:value-of select="concat('-', @name)"/>
  </xsl:template>

  <xsl:template match="@*" mode="axsd:title-suffix">
    <xsl:value-of select="' '"/>

    <code>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>

  <xsl:template match="@base" mode="axsd:title-suffix">
    <xsl:value-of select="' of '"/>

    <xsl:apply-templates select="." mode="axsd:linkto"/>
  </xsl:template>

  <xsl:template match="@default|@fixed" mode="axsd:title-suffix">
    <xsl:value-of select="concat(', ', name(.), ' ')"/>

    <code>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>

  <xsl:template match="@itemType|@type" mode="axsd:title-suffix">
    <xsl:value-of select="' of type '"/>

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
    <xsl:variable name="localName" select="local-name(.)"/>

    <xsl:for-each select="document('')">
      <xsl:value-of
          select="key('axsd:elements', $localName)/@rdfs:label"/>
    </xsl:for-each>

    <xsl:value-of select="' '"/>

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

  <xsl:template match="xsd:attribute" mode="a:title">
    <xsl:apply-templates select="@name|@ref" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@type" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@use" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@default|@fixed" mode="axsd:title-suffix"/>
  </xsl:template>

  <xsl:template match="xsd:element" mode="a:title">
    <xsl:apply-templates select="@name|@ref" mode="axsd:title-suffix"/>

    <xsl:apply-templates select="@type" mode="axsd:title-suffix"/>

    <xsl:call-template name="a:occurrence"/>
  </xsl:template>

  <xsl:template match="/*/xsd:*" mode="a:title">
    <xsl:choose>
      <xsl:when test="@abstract = 'true'">
        <xsl:for-each select="document('')">
          <xsl:value-of
              select="key('axsd:elements', 'abstractComplexType')/@rdfs:label"/>
        </xsl:for-each>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="localName" select="local-name(.)"/>

        <xsl:for-each select="document('')">
          <xsl:value-of
              select="key('axsd:elements', $localName)/@rdfs:label"/>
        </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>

    <xsl:value-of select="' '"/>

    <code>
      <xsl:value-of select="@name|@ref"/>
    </code>
  </xsl:template>

  <xsl:template match="*" mode="axsd:heading">
    <p>
      <xsl:apply-templates select="." mode="a:title"/>
    </p>
  </xsl:template>

  <xsl:template match="/*/*" mode="axsd:heading">
    <xsl:apply-templates select="." mode="a:h3"/>
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

  <xsl:template match="xsd:documentation[xh:*]" mode="axsd:main">
    <div class="xsd-documentation">
      <xsl:apply-templates mode="a:copy"/>
    </div>
  </xsl:template>

  <xsl:template
      match="xsd:annotation|xsd:documentation|xsd:simpleType[not(@*)]"
      mode="axsd:main">
    <xsl:apply-templates mode="axsd:main"/>
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

      <ul class="xsd-{local-name(.)}">
        <xsl:apply-templates mode="axsd:main"/>
      </ul>
    </section>
  </xsl:template>

  <xsl:template
      match="xsd:choice/xsd:choice|xsd:choice/xsd:sequence|xsd:sequence/xsd:choice|xsd:sequence/xsd:sequence"
      mode="axsd:main">
    <li>
      <xsl:apply-templates select="." mode="axsd:heading"/>

      <ul class="xsd-{local-name(.)}">
        <xsl:apply-templates mode="axsd:main"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template
      match="xsd:import"
      mode="axsd:tr"
      rdfs:label="Create &lt;tr&gt;">
    <tr>
      <td>
        <code>
          <xsl:value-of select="@namespace"/>
        </code>
      </td>

      <td>
        <a href="{@schemaLocation}">
          <xsl:value-of select="@schemaLocation"/>
        </a>
      </td>
    </tr>
  </xsl:template>

  <xsl:template
      match="xsd:include"
      mode="axsd:li"
      rdfs:label="Create &lt;li&gt;">
    <li>
        <a href="{@schemaLocation}">
          <xsl:value-of select="@schemaLocation"/>
        </a>
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
          <xsl:apply-templates select="/*/xsd:import" mode="axsd:tr"/>
        </tbody>
      </table>
    </section>
  </xsl:template>

  <xsl:template match="xsd:include[1]" mode="axsd:main">
    <section>
      <h2 id="includes">Includes</h2>

      <ul>
        <xsl:apply-templates select="/*/xsd:include" mode="axsd:li"/>
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
          select="following::*[parent::xsd:schema][local-name(.) != 'import'][local-name(.) != 'include']"/>

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

  <xsl:template
      match="xsd:import"
      mode="axsd:toc-li"
      rdfs:label="Create &lt;li&gt; for the TOC">
    <li>
      <p>
        <a href="#imports">Imports</a>
      </p>
    </li>
  </xsl:template>

  <xsl:template
      match="xsd:include"
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
          <a href="#xsd-refs">XSD references</a>
        </p>
      </li>
    </ul>
  </xsl:template>

  <xsl:template
      name="axsd:references"
      rdfs:label="Create references &lt;h2&gt; and  &lt;ul&gt;">
    <h2 id="xslt-references">XSD references</h2>

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
