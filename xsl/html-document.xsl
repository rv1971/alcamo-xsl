<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    version="1.0"
    xml:lang="en"
    dc:identifier="html-document"
    dc:title="HTML document creation"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2023-05-16">
  <xsl:import href="html.xsl"/>
  <xsl:import href="metadata.xsl"/>
  <xsl:import href="html-document.alone.xsl"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Parameters</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <table class="alcamo">
        <tbody>
          <tr>
            <th class="code">output</th>
            <td>Report errors as HTML code in the result tree.</td>
          </tr>

          <tr>
            <th class="code">message</th>
            <td>Report errors via <code>&lt;xsl:message&gt;</code>.</td>
          </tr>

          <tr>
            <th class="code">both</th>
            <td>Report errors in both channels.</td>
          </tr>

          <tr>
            <th>any other value</th>
            <td>Do not report errors.</td>
          </tr>
        </tbody>
      </table>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:param
      name="a:errorReportingChannels"
      select="'both'"
      rdfs:label="How to report errors"/>

  <xsl:param
      name="a:cssList"
      rdfs:label="Whitespace-separated list of CSS files to link to"/>

  <xsl:param
      name="a:jsList"
      rdfs:label="Whitespace-separated list of JS files to link to"/>
</xsl:stylesheet>
