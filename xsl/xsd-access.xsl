<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    xmlns:axsd="tag:rv1971@web.de,2021:alcamo-xsl:xsd#"
    version="1.0"
    xml:lang="en"
    dc:identifier="xsd-access"
    dc:title="Access to XSD content"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-05-02"
    dc:modified="2023-05-08">
  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Variables</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:variable
      name="a:firstSchemaLocation"
      select="substring-before(
          concat(
              substring-after(normalize-space(/*/@xsi:schemaLocation), ' '),
              ' '
          ),
          ' '
      )"
      rdfs:label="Url of first schema in xsi:schemaLocation"/>

  <xsl:variable
      name="a:firstSchema"
      select="document($a:firstSchemaLocation, /*)"
      rdfs:label="XSD loaded from $a:firstSchemaLocation"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Keys</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:key
      name="axsd:attributes"
      match="/*/xsd:attribute"
      use="@name"
      rdfs:label="Top-level attributes declared in the current document"/>

  <xsl:key
      name="axsd:attributeGroups"
      match="/*/xsd:attributeGroup"
      use="@name"
      rdfs:label="Attribute groups declared in the current document"/>

  <xsl:key
      name="axsd:elements"
      match="/*/xsd:element"
      use="@name"
      rdfs:label="Top-level elements declared in the current document"/>

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

  <xsl:key
      name="axsd:imports"
      match="/*/xsd:import"
      use="@namespace"
      rdfs:label="Imports present in the current document"/>

  <xsl:key
      name="axsd:namedRestrictions"
      match="/*/xsd:simpleType|/*/xsd:complexType"
      use="xsd:restriction/@base"
      rdfs:label="Top-level restriction types defined in the current document"/>

  <xsl:key
      name="axsd:namedExtensions"
      match="/*/xsd:complexType"
      use="xsd:complexContent/xsd:extension/@base|xsd:simpleContent/xsd:extension/@base"
      rdfs:label="Top-level extension types defined in the current document"/>

  <xsl:key
      name="axsd:localElements"
      match="/*/xsd:*//xsd:element"
      use="@name"
      rdfs:label="Elements declared locally in the current document"/>

  <xsl:key
      name="axsd:elements-with-id"
      match="//xsd:*[@id]"
      use="@id"
      rdfs:label="Elements with ID"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>IDs for use in HTML</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Create a unique ID for any XSD element in a schema:</p>

      <ul>
        <li>Take from each level the local tag name and the
        <code>name</code>, <code>ref</code> or <code>value</code>
        attribute, if present, separated by a hyphen.</li>
        <li>In each level, append a dot and a counter if there are
        siblings with the same tag name that are not uniquely
        identified by <code>name</code>, <code>ref</code> or
        <code>value</code>. Note that in a
        <code>&lt;sequence&gt;</code>, elements with the same
        <code>name</code> or <code>ref</code> can occur multiple
        times. The counter counts siblings with the same tag name, the
        first sibling has number 1.</li>
        <li>Compose an ID recursively, separating levels by a dot,
        starting with top-level elements in the document. At
        intermediate levels, skip elements that are not needed to make
        the result unique, such as
        <code>&lt;restriction&gt;</code>. The implementation relies on
        the fact that these elements cannot occur at top level.</li>
      </ul>

      <p>The result is a valid <a
      href="https://www.w3.org/TR/xml/#NT-Name">XML Name</a>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="xsd:*" mode="a:id" rdfs:label="Create ID text">
    <xsl:param name="intermediate"/>

    <xsl:if test="count(..|/*) = 2">
      <xsl:apply-templates select=".." mode="a:id">
        <xsl:with-param name="intermediate" select="1"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:if
        test="not($intermediate) or not(self::xsd:complexContent|self::xsd:extension|self::xsd:restriction|self::xsd:simpleContent)">
      <xsl:if test="count(..|/*) = 2">
        <xsl:text>.</xsl:text>
      </xsl:if>

      <xsl:choose>
        <xsl:when
            test="local-name() = 'simpleType' or local-name() = 'complexType'">
          <xsl:value-of select="'type'"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="local-name()"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="@name|@ref|@value">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@name|@ref|@value"/>
      </xsl:if>

      <xsl:if test="not(@name|@ref|@value) or parent::xsd:sequence">
        <xsl:if test="count(../xsd:*[local-name() = local-name(current())]) > 1">
          <xsl:text>.</xsl:text>
          <xsl:value-of
              select="count(preceding-sibling::xsd:*[local-name() = local-name(current())]) + 1"/>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Lookup of data in the schema</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Return the first non-empty of:</p>

      <ul>
        <li>The <code>rdfs:label</code> attribute of the element
        declaration.</li>
        <li>The <code>rdfs:label</code> attribute of the type
        definition referenced by the element declaration, if available.</li>
        <li>The element's local name.</li>
      </ul>

      <p><b>NOTE:</b> This works only if the default namespace in the
      XSD is the target namepsace.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="axsd:label"
      match="*"
      mode="axsd:label"
      rdfs:label="Lookup the label of an element">
    <xsl:param
        name="localName"
        select="local-name(.)"
        rdfs:label="Local name of element to look up label for"/>
    <xsl:param
        name="schema"
        select="$a:firstSchema"
        rdfs:label="XSD to search in"/>

    <xsl:for-each select="$a:firstSchema">
      <xsl:variable
          name="declaration"
          select="key('axsd:elements', $localName)"/>

      <xsl:choose>
        <xsl:when test="$declaration/@rdfs:label">
          <xsl:value-of select="$declaration/@rdfs:label"/>
        </xsl:when>

        <xsl:when test="$declaration/@type">
          <xsl:variable
              name="type"
              select="key('axsd:types', $declaration/@type)"/>

          <xsl:choose>
            <xsl:when test="$type/@rdfs:label">
              <xsl:value-of select="$type/@rdfs:label"/>
            </xsl:when>

            <xsl:otherwise>
              <xsl:value-of select="$declaration/@type"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="$localName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
