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
    version="1.0"
    exclude-result-prefixes="a dc rdfs xh xsd"
    xml:lang="en"
    dc:identifier="annotation.alone"
    dc:title="Process &lt;xsd:annotation&gt;"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2023-05-26">
  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>Templates to collect HTML documentation contained in
      <code>&lt;xsd:annotation&gt;&lt;xsd:documentation&gt;...&lt;/xsd:annotation&gt;&lt;/xsd:documentation&gt;</code>
      blocks, creating TOC entries based on <code>&lt;h2&gt;</code>
      and <code>&lt;h3&gt;</code> elements in these blocks.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Variables</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:variable
      name="a:htmlDoc"
      select="//xsd:annotation/xsd:documentation//xh:*"
      rdfs:label="All HTML content in documentation blocks"/>

  <xsl:variable
      name="a:about"
      select="/*/*[1][self::xsd:annotation]/xsd:documentation[xh:*][1]"
      rdfs:label="The first documentation block with HTML content, if it is the first child of the document element"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Mode <code>a:copy</code></h2>
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

  <xsl:template match="xsd:annotation|xsd:documentation" mode="a:copy">
    <xsl:apply-templates select="@*|node()" mode="a:copy"/>
  </xsl:template>

  <xsl:template
      match="xh:h2|xh:h3|xh:h4|xh:h5|xh:h6"
      mode="a:copy"
      rdfs:label="create heading element with ID">
    <xsl:element name="{name()}">
      <xsl:if test="not(@id)">
        <xsl:attribute name="id">
          <xsl:call-template name="a:id"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:apply-templates select="@*|node()" mode="a:copy"/>
    </xsl:element>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>TOC items</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="*"
      mode="a:toc-li"
      rdfs:label="Create simple TOC &lt;li>">
    <li>
      <xsl:apply-templates select="." mode="a:a"/>
    </li>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
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

        <xsl:if test="$subToc != ''">
          <ul>
            <xsl:copy-of select="$subToc"/>
          </ul>
        </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Page content</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Prepend an <code>&lt;h2&gt;</code> heading "About" to
      <code>$a:about</code> if the latter contains no
      <code>&lt;h2&gt;</code>.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      match="xsd:documentation"
      mode="a:about"
      rdfs:label="Create about-block">
    <xsl:if test="not(.//xh:h2)">
      <h2 id="about">About</h2>
    </xsl:if>

    <xsl:apply-templates mode="a:copy"/>
  </xsl:template>
</xsl:stylesheet>
