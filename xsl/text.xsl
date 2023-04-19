<?xml version="1.0" encoding="UTF-8"?>

<?xml-stylesheet href="xsl.xsl" type="text/xsl"?>

<xsl:stylesheet
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="tag:rv1971@web.de,2021:alcamo-xsl#"
    version="1.0"
    xml:lang="en"
    dc:identifier="text"
    dc:title="Text generation"
    dc:creator="https://github.com/rv1971"
    dc:created="2023-04-13"
    dc:modified="2023-04-19">

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2 id="embedded">Embedded data</h2>
    </xsd:documentation>
  </xsd:annotation>

  <a:numbers rdfs:label="Spelling of numbers">
    <a:number id="0" >zero</a:number>
    <a:number id="1" >one</a:number>
    <a:number id="2" >two</a:number>
    <a:number id="3" >three</a:number>
    <a:number id="4" >four</a:number>
    <a:number id="5" >five</a:number>
    <a:number id="6" >six</a:number>
    <a:number id="7" >seven</a:number>
    <a:number id="8" >eight</a:number>
    <a:number id="9" >nine</a:number>
    <a:number id="10">ten</a:number>
  </a:numbers>

  <xsl:key
      name="a:numbers"
      match="/*/a:numbers/a:number"
      use="@id"/>

  <a:hexDigits rdfs:label="Hexadecimal digits">
    <a:hexDigit id="0">0</a:hexDigit>
    <a:hexDigit id="1">1</a:hexDigit>
    <a:hexDigit id="2">2</a:hexDigit>
    <a:hexDigit id="3">3</a:hexDigit>
    <a:hexDigit id="4">4</a:hexDigit>
    <a:hexDigit id="5">5</a:hexDigit>
    <a:hexDigit id="6">6</a:hexDigit>
    <a:hexDigit id="7">7</a:hexDigit>
    <a:hexDigit id="8">8</a:hexDigit>
    <a:hexDigit id="9">9</a:hexDigit>
    <a:hexDigit id="10">A</a:hexDigit>
    <a:hexDigit id="11">B</a:hexDigit>
    <a:hexDigit id="12">C</a:hexDigit>
    <a:hexDigit id="13">D</a:hexDigit>
    <a:hexDigit id="14">E</a:hexDigit>
    <a:hexDigit id="15">F</a:hexDigit>
  </a:hexDigits>

  <xsl:key
      name="a:hexDigits"
      match="/*/a:hexDigits/a:hexDigit"
      use="@id"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2 id="numbers">Numbers</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Spell out a number if present in the above table, otherwise
      output it unchanged.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:number"
      rdfs:label="Create spelled-out number if available, otherwise unchanged $value ">
    <xsl:param name="value" select="." rdfs:label="Number to spell out"/>

    <xsl:for-each select="document('')">
      <xsl:choose>
        <xsl:when test="key('a:numbers',$value)">
          <xsl:value-of select="string(key('a:numbers', $value))"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="string($value)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*|@*" mode="a:number">
    <xsl:call-template name="a:number"/>
  </xsl:template>

  <xsl:template
      name="a:hex"
      rdfs:label="Create hex representation">
    <xsl:param name="value" select="." rdfs:label="Number to convert"/>

    <xsl:if test="$value >= 16">
      <xsl:call-template name="a:hex">
        <xsl:with-param name="value" select="floor($value div 16)" />
      </xsl:call-template>
    </xsl:if>

    <xsl:for-each select="document('')">
      <xsl:value-of select="string(key('a:hexDigits', $value mod 16))"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*|@*" mode="a:hex">
    <xsl:call-template name="a:hex"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2 id="plurals">Plurals</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template name="a:plural" rdfs:label="Create '# thing(s)'">
    <xsl:param name="value" select="." rdfs:label="Number of things"/>
    <xsl:param name="singular" rdfs:label="Unit name in singular form"/>
    <xsl:param
        name="plural"
        select="concat($singular, 's')"
        rdfs:label="Unit name in plural form"/>

    <xsl:choose>
      <xsl:when test="$value = 1">
        <xsl:value-of select="concat($value, ' ', $singular)"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="concat($value, ' ', $plural)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2 id="iso-8601">ISO 8601</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>If a value expressing an ISO 8601 timestamp contains a
      <code>T</code>, replace it by one space for better
      readibility.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:iso-8601-timestamp"
      rdfs:label="Create timestamp text">
    <xsl:param name="value" select="." rdfs:label="Timestamp to format"/>

    <xsl:value-of select="translate($value, 'T', ' ')"/>
  </xsl:template>

  <xsl:template
      match="*|@*"
      mode="a:iso-8601-timestamp"
      rdfs:label="create timestamp text">
    <xsl:value-of select="translate(., 'T', ' ')"/>
  </xsl:template>

  <xsl:template
      name="a:iso-8601-duration-date"
      rdfs:label="Create duration text for date component">
    <xsl:param
        name="value"
        select="."
        rdfs:label="Duration date component to format"/>

    <xsl:choose>
      <xsl:when test="contains($value, 'Y')">
        <xsl:call-template name="a:plural">
          <xsl:with-param name="value" select="substring-before($value, 'Y')"/>
          <xsl:with-param name="singular" select="'year'"/>
        </xsl:call-template>

        <xsl:if test="substring-after($value, 'Y')">
          <xsl:value-of select="' '"/>

          <xsl:call-template name="a:iso-8601-duration-date">
            <xsl:with-param name="value" select="substring-after($value, 'Y')"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>

      <xsl:when test="contains($value, 'M')">
        <xsl:call-template name="a:plural">
          <xsl:with-param name="value" select="substring-before($value, 'M')"/>
          <xsl:with-param name="singular" select="'month'"/>
        </xsl:call-template>

        <xsl:if test="substring-after($value, 'M')">
          <xsl:value-of select="' '"/>

          <xsl:call-template name="a:iso-8601-duration-date">
            <xsl:with-param name="value" select="substring-after($value, 'M')"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>

      <xsl:when test="contains($value, 'W')">
        <xsl:call-template name="a:plural">
          <xsl:with-param name="value" select="substring-before($value, 'W')"/>
          <xsl:with-param name="singular" select="'week'"/>
        </xsl:call-template>

        <xsl:if test="substring-after($value, 'W')">
          <xsl:value-of select="' '"/>

          <xsl:call-template name="a:iso-8601-duration-date">
            <xsl:with-param name="value" select="substring-after($value, 'W')"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>

      <xsl:when test="contains($value, 'D')">
        <xsl:call-template name="a:plural">
          <xsl:with-param name="value" select="substring-before($value, 'D')"/>
          <xsl:with-param name="singular" select="'day'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      name="a:iso-8601-duration-time"
      rdfs:label="Create duration text for time component">
    <xsl:param
        name="value"
        select="."
        rdfs:label="Duration time component to format"/>

    <xsl:choose>
      <xsl:when test="contains($value, 'H')">
        <xsl:call-template name="a:plural">
          <xsl:with-param name="value" select="substring-before($value, 'H')"/>
          <xsl:with-param name="singular" select="'hour'"/>
        </xsl:call-template>

        <xsl:if test="substring-after($value, 'H')">
          <xsl:value-of select="' '"/>

          <xsl:call-template name="a:iso-8601-duration-time">
            <xsl:with-param name="value" select="substring-after($value, 'H')"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>

      <xsl:when test="contains($value, 'M')">
        <xsl:call-template name="a:plural">
          <xsl:with-param name="value" select="substring-before($value, 'M')"/>
          <xsl:with-param name="singular" select="'minute'"/>
        </xsl:call-template>

        <xsl:if test="substring-after($value, 'M')">
          <xsl:value-of select="' '"/>

          <xsl:call-template name="a:iso-8601-duration-time">
            <xsl:with-param name="value" select="substring-after($value, 'M')"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>

      <xsl:when test="contains($value, 'S')">
        <xsl:call-template name="a:plural">
          <xsl:with-param name="value" select="substring-before($value, 'S')"/>
          <xsl:with-param name="singular" select="'second'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template
      name="a:iso-8601-duration"
      rdfs:label="create duration text">
    <xsl:param name="value" select="." rdfs:label="Duration to format"/>

    <xsl:choose>
      <xsl:when test="contains($value, 'T')">
        <xsl:variable
            name="dateComponent"
            select="substring-before(substring($value, 2), 'T')"/>

        <xsl:if test="$dateComponent">
          <xsl:call-template name="a:iso-8601-duration-date">
            <xsl:with-param name="value" select="$dateComponent"/>
          </xsl:call-template>

          <xsl:value-of select="' '"/>
        </xsl:if>

        <xsl:call-template name="a:iso-8601-duration-time">
          <xsl:with-param name="value" select="substring-after($value, 'T')"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="a:iso-8601-duration-date">
          <xsl:with-param name="value" select="substring($value, 2)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*|@*" mode="a:iso-8601-duration">
    <xsl:call-template name="a:iso-8601-duration"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2 id="auto-mode"><code>auto</code> mode</h2>

      <p>By default, the <code>auto</code> mode copies a node value
      verbatim to the result tree. Hence this mode can be used to
      format anything, and more specific templates can be defined to
      add functionality.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="node()" mode="a:auto" rdfs:label="Copy node">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template
      match="@dc:created|dc:created|@dc:modified|dc:modified"
      mode="a:auto"
      rdfs:label="Create timestamp text">
    <xsl:call-template name="a:iso-8601-timestamp"/>
  </xsl:template>
</xsl:stylesheet>
