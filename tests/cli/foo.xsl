<?xml version="1.0"?>

<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:php="http://php.net/xsl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:template match="/">
    <bar>
      <xsl:value-of select="php:functionString('myfunc', /*)"/>
    </bar>
  </xsl:template>
</xsl:stylesheet>
