<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    xml:id="xslt"
    version="1.0">
  <xsl:import href="../xsl/metadata.xsl"/>

  <xsl:template match="/">
    <a:result>
      <a:item>
        <xsl:value-of select="$a:xslUrl"/>
      </a:item>

      <a:item>
        <xsl:value-of select="$a:xslDirUrl"/>
      </a:item>
    </a:result>
  </xsl:template>
</xsl:stylesheet>
