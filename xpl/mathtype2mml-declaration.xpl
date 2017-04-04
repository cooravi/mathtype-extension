<?xml version="1.0"?>
<p:declare-step  
  xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:tr="http://transpect.io" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  version="1.0"
  type="tr:mathtype2mml">

  <p:documentation>Convert an OLE-Object containing a Mathtype equation to MathML.
  Uses Jruby to create an XML-representation of the MTEF formula.</p:documentation>

  <p:output port="result" primary="true" sequence="true">
    <p:documentation>The MathML equation from file @href.</p:documentation>
  </p:output>
  <p:output port="mtef-xml" primary="false" sequence="true">
    <p:documentation>The xml produced by mtef2xml step.</p:documentation>
    <p:pipe port="result" step="mtef2xml"/>
  </p:output>
  <p:option name="href">
    <p:documentation>The equation file URI. (OLE-Object)</p:documentation>
  </p:option>

  <p:import href="mtef2xml-declaration.xpl"/>

  <tr:mtef2xml name="mtef2xml">
	 <p:with-option name="href" select="$href"/>
  </tr:mtef2xml>

  <p:xslt name="xml2mml">
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/transform.xsl"/>
    </p:input>
  </p:xslt>

  <p:xslt initial-mode="repair-subsup" name="repair-subsup">
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/repair-subsup.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt initial-mode="combine-elements" name="combine-elements">
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/combine-elements.xsl"/>
    </p:input>
  </p:xslt>

</p:declare-step>
