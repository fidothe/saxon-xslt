<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eg="http://example.org/ns" version="2.0" exclude-result-prefixes="eg">
  <xsl:param name="testparam">default</xsl:param>
  <xsl:param name="eg:qname-param" select="false()"/>
  <xsl:template match="input">
    <xsl:choose>
      <xsl:when test="$testparam = 'default'">
        <output/>
      </xsl:when>
      <xsl:when test="$testparam = 'input'">
        <output>
          Select works
        </output>
      </xsl:when>
      <xsl:otherwise>
        <output>
          <xsl:value-of select="$testparam" />
        </output>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$eg:qname-param">
      <qname-param/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
