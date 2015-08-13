<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:param name="testparam">default</xsl:param>
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
  </xsl:template>
</xsl:stylesheet>
