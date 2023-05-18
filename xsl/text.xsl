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
    dc:modified="2023-05-17">
  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Introduction</h2>

      <p>General-purpose templates that generate text.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Embedded data</h2>
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

  <xsl:variable
      name="a:textXslDoc"
      select="document('')"
      rdfs:label="This document"/>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Case folding</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:tolower"
      match="*|@*"
      mode="a:tolower"
      rdfs:label="Convert to lowercase">
    <xsl:param name="text" select="." rdfs:label="Text to convert"/>

    <xsl:value-of
        select="translate($text, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
  </xsl:template>

  <xsl:template
      name="a:toupper"
      match="*|@*"
      mode="a:toupper"
      rdfs:label="Convert to uppercase">
    <xsl:param name="text" select="." rdfs:label="Text to convert"/>

    <xsl:value-of
        select="translate($text, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
  </xsl:template>

  <xsl:template
      name="a:ucfirst"
      match="*|@*"
      mode="a:ucfirst"
      rdfs:label="Convert first character to uppercase">
    <xsl:param name="text" select="." rdfs:label="Text to convert"/>

    <xsl:value-of
        select="concat(translate(substring($text, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring($text, 2))"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>QName handling</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:local-name"
      match="*|@*"
      mode="a:local-name">
    <xsl:param name="qname" select="." rdfs:label="Text to extract from"/>

    <xsl:choose>
      <xsl:when test="contains($qname, ':')">
        <xsl:value-of select="substring-after($qname, ':')"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$qname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>ID handling</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*" mode="a:title" rdfs:label="Create title text">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template
      name="a:id"
      match="*|@*"
      mode="a:id"
      rdfs:label="Convert to lowercase ID, replacing spaces by hyphens and removing punctuation">
    <xsl:param name="text" rdfs:label="Text to convert">
      <xsl:apply-templates select="." mode="a:title"/>
    </xsl:param>

    <xsl:variable name="from">ABCDEFGHIJKLMNOPQRSTUVWXYZ !"#$%&amp;'()*+,./:;&lt;&gt;?@[\]^`{|}~</xsl:variable>

    <xsl:value-of
        select="translate($text, $from, 'abcdefghijklmnopqrstuvwxyz-')"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Use an existing <code>id</code> attribute, or generate one of
      there is none.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="*[@xml:id]" mode="a:id" rdfs:label="Create ID text">
    <xsl:value-of select="@xml:id"/>
  </xsl:template>

  <xsl:template
      match="*[not(@xml:id)][@id]"
      mode="a:id"
      rdfs:label="Create ID text">
    <xsl:value-of select="@id"/>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Numbers</h2>
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
      match="*|@*"
      mode="a:number"
      rdfs:label="Create spelled-out number if available, otherwise unchanged $value ">
    <xsl:param name="value" select="." rdfs:label="Number to spell out"/>

    <xsl:for-each select="$a:textXslDoc">
      <xsl:choose>
        <xsl:when test="key('a:numbers', number($value))">
          <xsl:value-of select="string(key('a:numbers', number($value)))"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="number($value)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template
      name="a:hex"
      match="*|@*"
      mode="a:hex"
      rdfs:label="Create hex representation">
    <xsl:param name="value" select="." rdfs:label="Number to convert"/>

    <xsl:if test="$value >= 16">
      <xsl:call-template name="a:hex">
        <xsl:with-param name="value" select="floor($value div 16)" />
      </xsl:call-template>
    </xsl:if>

    <xsl:for-each select="$a:textXslDoc">
      <xsl:value-of select="string(key('a:hexDigits', $value mod 16))"/>
    </xsl:for-each>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>Counting</h2>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template name="a:range" rdfs:label="Create text">
    <xsl:param name="min" rdfs:label="Minimum value"/>
    <xsl:param name="max" rdfs:label="Maximum value"/>
    <xsl:param name="defaultMin" rdfs:label="Default minimum value" select="0"/>

    <xsl:variable name="actualMin">
      <xsl:choose>
        <xsl:when test="$min">
          <xsl:value-of select="$min"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="$defaultMin"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="actualMax">
      <xsl:choose>
        <xsl:when test="$max">
          <xsl:value-of select="$max"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="'∞'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$actualMin = $actualMax">
        <xsl:value-of select="$actualMin"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="concat($actualMin, '-', $actualMax)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="a:occurrence" rdfs:label="Create text">
    <xsl:param
        name="minOccurs"
        select="@minOccurs"
        rdfs:label="Minimum number of allowed occurrences"/>
    <xsl:param
        name="maxOccurs"
        select="@maxOccurs"
        rdfs:label="Maximum number of allowed occurrences"/>

    <xsl:choose>
      <xsl:when test="$minOccurs and $minOccurs != 1">
        <xsl:choose>
          <xsl:when test="$maxOccurs and $maxOccurs != 1">
            <xsl:choose>
              <xsl:when test="$maxOccurs = 'unbounded'">
                <xsl:value-of select="', '"/>
                <xsl:apply-templates select="$minOccurs" mode="a:number"/>
                <xsl:value-of select="' or more'"/>
              </xsl:when>

              <xsl:when test="$maxOccurs = $minOccurs">
                <xsl:value-of select="', exactly '"/>
                <xsl:apply-templates select="$minOccurs" mode="a:number"/>
              </xsl:when>

              <xsl:otherwise>
                <xsl:value-of select="', '"/>
                <xsl:apply-templates select="$minOccurs" mode="a:number"/>
                <xsl:value-of select="' to '"/>
                <xsl:apply-templates select="$maxOccurs" mode="a:number"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="', optional'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$maxOccurs and $maxOccurs != 1">
        <xsl:choose>
          <xsl:when test="$maxOccurs = 'unbounded'">
            <xsl:value-of select="', one or more'"/>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="', one to '"/>
            <xsl:apply-templates select="$maxOccurs" mode="a:number"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

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

  <xsl:template name="a:range-plural" rdfs:label="Create '#-# thing(s)'">
    <xsl:param name="min" rdfs:label="Minimum value"/>
    <xsl:param name="max" rdfs:label="Maximum value"/>
    <xsl:param name="defaultMin" rdfs:label="Default minimum value" select="0"/>
    <xsl:param name="singular" rdfs:label="Unit name in singular form"/>
    <xsl:param
        name="plural"
        select="concat($singular, 's')"
        rdfs:label="Unit name in plural form"/>

    <xsl:call-template name="a:range">
      <xsl:with-param name="min" select="$min"/>
      <xsl:with-param name="max" select="$max"/>
      <xsl:with-param name="defaultMin" select="$defaultMin"/>
    </xsl:call-template>

    <xsl:text> </xsl:text>

    <xsl:choose>
      <xsl:when test="$max = 1">
        <xsl:value-of select="$singular"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$plural"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2>ISO 8601</h2>
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
      match="*|@*"
      mode="a:iso-8601-timestamp"
      rdfs:label="Create timestamp text">
    <xsl:param name="value" select="." rdfs:label="Timestamp to format"/>

    <xsl:value-of select="translate($value, 'T', ' ')"/>
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

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>This template rule does not check whether the input is a
      valid ISO 8601 duration and gives undefined results if this is
      not the case.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template
      name="a:iso-8601-duration"
      match="*|@*"
      mode="a:iso-8601-duration"
      rdfs:label="Create duration text">
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

  <xsd:annotation>
    <xsd:documentation xmlns="http://www.w3.org/1999/xhtml">
      <h2><code>auto</code> mode</h2>

      <p>By default, the <code>auto</code> mode copies a node value
      verbatim to the result tree. Hence this mode can be used to
      format anything, and more specific templates can be defined to
      add functionality.</p>
    </xsd:documentation>
  </xsd:annotation>

  <xsl:template match="node()" mode="a:auto" rdfs:label="Copy node">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template
      match="@dc:created|dc:created|@dc:modified|dc:modified"
      mode="a:auto"
      rdfs:label="Create timestamp text">
    <xsl:call-template name="a:iso-8601-timestamp"/>
  </xsl:template>
</xsl:stylesheet>
