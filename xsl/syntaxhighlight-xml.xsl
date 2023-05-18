<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    xml:lang="en"
    dc:identifier="syntaxhighlight-xml"
    dc:title="Syntax highlighting for XML code"
    dc:creator="https://github.com/rv1971"
    dc:created="2017-09-11"
    dc:modified="2023-05-18">
  <xsl:import href="syntaxhighlight-xml.alone.xsl"/>

  <xsd:annotation>
    <xsd:documentation>
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="sh:indent"
      select="'  '"
      rdfs:label="Indentation string to add on each level of recursion"/>

  <xsl:param
      name="sh:attrIndent"
      select="'    '"
      rdfs:label="Indentation string to add for attributes"/>

  <xsl:param
      name="sh:maxInlineAttrs"
      select="1"
      rdfs:label="Maximum number of inline attributes"/>

  <xsl:param
      name="sh:maxInlineAttrLength"
      select="60"
      rdfs:label="Maximum length of inline attributes"/>

  <xsl:param
      name="sh:maxInlineTextLength"
      select="40"
      rdfs:label="Maximum length of inline text"/>
</xsl:stylesheet>
