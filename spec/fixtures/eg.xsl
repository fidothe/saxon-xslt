<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:param name="testparam">default</xsl:param>
  <xsl:template match="input">
    <output/>
  </xsl:template>
  <xsl:template match="output">
    <piped/>
  </xsl:template>
</xsl:stylesheet>
