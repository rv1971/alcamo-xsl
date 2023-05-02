<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    xmlns:axsd="tag:rv1971@web.de,2021:alcamo-xsl:xsd#"
    version="1.0"
    xml:lang="en"
    dc:identifier="xsd-access"
    dc:title="Keys to access XSD content"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-05-02"
    dc:modified="2023-05-02">
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

  <xsl:key
      name="axsd:elements-with-id"
      match="//xsd:*[@id]"
      use="@id"
      rdfs:label="Elements with ID"/>
</xsl:stylesheet>
