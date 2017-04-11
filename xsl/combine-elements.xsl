<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY functions "('ln','max','min','cos','sin')">
]>
<xsl:stylesheet 
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns="http://www.w3.org/1998/Math/MathML"
	 xpath-default-namespace="http://www.w3.org/1998/Math/MathML"
	 version="2.0">
  <xsl:import href="identity.xsl"/>
  <xsl:template match="*[count(mtext) ge 2]" mode="combine-mtext">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:for-each-group group-adjacent="boolean(self::mtext[(
        (not(@mathvariant) or @mathvariant='normal') 
        and 
        preceding-sibling::*[1][self::mtext][not(@mathvariant) or @mathvariant='normal']
      ) or (every $a in (@* except @mathvariant) satisfies (some $pa in preceding-sibling::*[1]/@* satisfies $pa = $a))])" select="node()">
        <xsl:choose>
          <xsl:when test="current-grouping-key()">
            <mtext>
              <xsl:apply-templates select="current()[1]/@mathvariant"/>
              <xsl:value-of select="current-group()/text()"/>
            </mtext>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="#current" select="current-group()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="*[count(mn) ge 2]" mode="combine-mn">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:for-each-group group-adjacent="local-name() = 'mn' and (not(preceding-sibling::*[1] = mn) or (every $a in ./@* satisfies (some $pa in preceding-sibling::*[1]/@* satisfies $pa = $a)))" select="node()">
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <xsl:choose>
            <xsl:when test="current-group()[1]/@start-function">
              <mi mathvariant="normal">
                <xsl:apply-templates select="current-group()[1]/@* except @start-function"/>
                <xsl:value-of select="current-group()/text()"/>
              </mi>
            </xsl:when>
            <xsl:otherwise>
              <mn>
                <xsl:apply-templates select="current()[1]/@*"/>
                <xsl:value-of select="current-group()/text()"/>
              </mn>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="#current" select="current-group()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="/" mode="combine-elements">
    <xsl:variable name="combine-mn">
      <xsl:apply-templates mode="combine-mn" select="."/>
    </xsl:variable>
    <xsl:apply-templates mode="combine-mtext" select="$combine-mn"/>
  </xsl:template>
</xsl:stylesheet>
