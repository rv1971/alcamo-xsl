<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    exclude-result-prefixes="a dc owl rdfs xh xsd"
    xml:lang="en"
    dc:identifier="annotation"
    dc:title="Process &lt;xsd:annotation&gt;"
    dc:creator="rv1971@web.de"
    dc:created="2023-04-13"
    dc:modified="2023-04-18">
  <xsl:import href="html-output.xsl"/>

  <xsd:annotation>
    <xsd:documentation>
      <h2 id="general">General</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="@*|node()"
      mode="a:copy"
      rdfs:label="Copy nodes unchanged">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="a:copy"/>
    </xsl:copy>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <h2 id="html">HTML</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xh:h2|xh:h3|xh:h4|xh:h5|xh:h6"
      mode="a:copy"
      rdfs:label="create heading element with ID">
    <xsl:element name="{name(.)}">
      <xsl:if test="not(@id)">
        <xsl:attribute name="id">
          <xsl:value-of select="generate-id(.)"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:apply-templates select="@*|node()" mode="a:copy"/>
    </xsl:element>
  </xsl:template>

  <xsl:variable
      name="a:htmlDoc"
      select="//xsd:annotation/xsd:documentation//xh:*"
      rdfs:label="All HTML elements in documentation blocks"/>

  <xsd:annotation>
    <xsd:documentation>
      <h2 id="toc-items">TOC items</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="a:toc-li"/>

  <xsl:template
      match="*"
      mode="a:toc-li"
      rdfs:label="Create simple TOC &lt;li>">
    <li>
      <xsl:apply-templates select="." mode="a:a"/>
    </li>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation>
      <p>Create a TOC entry as an <code>&lt;li&gt;</code> element linking
      to the <code>&lt;h2&gt;</code> element. Create a child
      <code>&lt;ul&gt;</code> element for <code>&lt;h3&gt;</code> elements,
      if any.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xh:h2"
      mode="a:toc-li"
      rdfs:label="create TOC &lt;li&gt;">
    <li>
      <xsl:apply-templates select="." mode="a:a"/>

      <!-- Intersect the set of all following <h3> elements with
           $a:htmlDoc. This is necessary because there might be <h3>
           in the document outside of annotations. -->

      <xsl:variable
          name="h3f"
          select="following::xh:h3[count($a:htmlDoc | .) = count($a:htmlDoc)]"/>

      <xsl:if test="$h3f">
        <!-- Get the next <h2> element, if any. To do that, intersect
             the set of all following <h2> elements with
             $a:htmlDoc. This is necessary because there might be <h2>
             in the document outside of annotations.-->

        <xsl:variable
            name="h2f"
            select="following::xh:h2[count($a:htmlDoc | .) = count($a:htmlDoc)][1]"/>

        <!-- Then intersect h3f with the set of all <h3> elements
             preceding the next <h2> element. If there is no
             subsequent <h2> element, simply take all following <h3>
             elements. Create the sub-toc out of this. -->

        <xsl:variable name="subToc">
          <xsl:choose>
            <xsl:when test="$h2f">
              <xsl:apply-templates
                  select="$h2f/preceding::xh:h3[count($h3f | .) = count($h3f)]"
                  mode="a:toc-li"/>
            </xsl:when>

            <xsl:otherwise>
              <xsl:apply-templates select="$h3f" mode="a:toc-li"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- If the sub-toc is nonempty, wrap it into a <ul> element. -->

        <xsl:if test="$subToc">
          <ul>
            <xsl:copy-of select="$subToc"/>
          </ul>
        </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>
</xsl:stylesheet>
