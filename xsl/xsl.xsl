<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    xmlns:sh="tag:rv1971@web.de,2021:alcamo-xsl:syntaxhighlight:xml#"
    version="1.0"
    xml:lang="en"
    dc:identifier="xsl"
    dc:title="Format an XSLT stylesheet for human readers"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-18"
    dc:modified="2023-05-18">
  <xsl:import href="annotation.xsl"/>
  <xsl:import href="html-document.xsl"/>
  <xsl:import href="syntaxhighlight-xml.xsl"/>
  <xsl:import href="xsl.alone.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="a:cssList"
      select="concat($a:xslDirUrl, 'css/alcamo.css', ' ', $a:xslDirUrl, 'css/syntaxhighlight.css', ' ', $a:xslDirUrl, 'css/xsl.css')"/>

  <xsl:param name="sh:maxInlineAttrs" select="3"/>
</xsl:stylesheet>
