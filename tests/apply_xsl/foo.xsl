<?xml version="1.0"?>

<xsl:stylesheet
    xmlns="http://xslt.example.org"
    xmlns:php="http://php.net/xsl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    exclude-result-prefixes="php">
  <xsl:param name="prefix"/>

  <xsl:template match="/">
    <bar>
      <xsl:value-of select="php:functionString('myfunc', $prefix, /*)"/>
    </bar>
  </xsl:template>
</xsl:stylesheet>
