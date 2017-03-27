<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl		= "http://www.w3.org/1999/XSL/Transform"
  xmlns:fn              = "http://www.w3.org/2005/xpath-functions"
  xmlns:xs		= "http://www.w3.org/2001/XMLSchema"
  xmlns:saxon		= "http://saxon.sf.net/"
  xmlns:letex		= "http://www.le-tex.de/namespace"
  exclude-result-prefixes = "xs saxon letex fn"
  >

  <!-- ================================================================================ -->
  <!-- OUTPUT FORMAT -->
  <!-- ================================================================================ -->

  <xsl:output
    method="xml"
    encoding="UTF-8"
    indent="yes"
    />

  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="ms mn mtext mi mo"/>

  <xsl:template match="@* | * | text() | processing-instruction()" mode="#all" priority="-1">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="#current">
        <xsl:sort select="name()"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
