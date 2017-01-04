<?xml version="1.0" encoding="utf-8" ?>
<!-- xsltproc -output nbEnseignant.htm partie1.xsl enseignants.xml -->
<xsl:stylesheet version="1.0"
		exclude-result-prefixes="xsl"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml">
  <xsl:template match="/">
    <html>
      <head>
	<title>nbEnseignant</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
      </head>
      <body>
	<h1>
	  L'université contient
	  <xsl:value-of select="count(//enseignant)"/>
	  enseignants.
	</h1>
      </body>
    </html>

  </xsl:template>
</xsl:stylesheet>
