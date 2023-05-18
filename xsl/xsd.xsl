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
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    xml:lang="en"
    dc:identifier="xsd"
    dc:title="Format an XSD for human readers"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-21"
    dc:modified="2023-05-18">
  <xsl:import href="annotation.xsl"/>
  <xsl:import href="html-document.xsl"/>
  <xsl:import href="syntaxhighlight-xml.xsl"/>
  <xsl:import href="xsd-access.xsl"/>
  <xsl:import href="xsd.alone.xsl"/>

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

  <xsl:param
      name="axsd:attrOverviewClasses"
      select="'xsd-attr-overview'"
      rdfs:label="CSS classes for attribute overview table"/>

  <xsl:param
      name="axsd:enumOverviewClasses"
      select="'xsd-enum-overview'"
      rdfs:label="CSS classes for enumerator overview table"/>

  <xsl:param
      name="axsd:genericAttrClasses"
      select="'xsd-generic-attrs'"
      rdfs:label="CSS classes for generic attributes table"/>
</xsl:stylesheet>
