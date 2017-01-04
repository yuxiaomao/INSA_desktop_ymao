<?xml version="1.0" encoding="utf-8" ?>
<!-- xsltproc -output listeTriEnseignant.htm partie3.xml enseignants.xml -->
<xsl:stylesheet version="1.0"
		exclude-result-prefixes="xsl"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml">
  <xsl:template match="/">
    <html>
      <head>
	<title>listeTriEnseignant</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
      </head>
      <body>
	<h1> Liste des personnes (tri par nom) </h1>   
	<blockquote>
	  <xsl:for-each select="//enseignant">
	    <xsl:sort select="nom"/>
	    <p><xsl:value-of select="nom"/></p>
	  </xsl:for-each>
	</blockquote>
      </body>
    </html>

  </xsl:template>
</xsl:stylesheet>
