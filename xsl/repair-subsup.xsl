<xsl:stylesheet 
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns="http://www.w3.org/1998/Math/MathML"
	 version="2.0">
  <xsl:import href="identity.xsl"/>
  
  <xsl:template match="msub|msup|msubsup" mode="repair-subsup">
	 <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
		<xsl:apply-templates select="preceding-sibling::*[1]" mode="#current">
		  <xsl:with-param name="keep" select="true()"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="node()" mode="#current"/>
	 </xsl:element>
  </xsl:template>

  <xsl:template
    match="*[following-sibling::*[1]/local-name() = 'msub'] |
           *[following-sibling::*[1]/local-name() = 'msup'] |
           *[following-sibling::*[1]/local-name() = 'msubsup']"
    mode="repair-subsup">
    <xsl:param name="keep" select="false()"/>
    <xsl:if test="$keep">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mmultiscripts" mode="repair-subsup">
	 <mmultiscripts>
      <xsl:choose>
        <xsl:when test="following-sibling::*">
          <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
            <xsl:with-param name="keep" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <mrow/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="#current"/>
	 </mmultiscripts>
  </xsl:template>

  <xsl:template match="*[preceding-sibling::*[1]/local-name() = 'mmultiscripts']" mode="repair-subsup">
	 <xsl:param name="keep" select="false()"/>
	 <xsl:if test="$keep">
		<xsl:next-match/>
	 </xsl:if>
  </xsl:template>
</xsl:stylesheet>
