<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
	<html>
		<body>		
			<!-- Execute a template when it matches a node "post_content" -->
			<xsl:apply-templates select="wp28/wp_posts/post_content"/>
		</body>
	</html>
	</xsl:template>
	
	<!-- Template for the node "post_content" -->
 	<xsl:template match="post_content">
 		<!-- Call the template with the parameter passing with the value of the current node -->
		<xsl:call-template name="findHref">
           	<xsl:with-param name="string" select="."/>
        </xsl:call-template>    
  	</xsl:template>
	
	<!-- Recursive search for substrings -->
    <xsl:template name="findHref">
    	<xsl:param name="string"/>
    	
		<xsl:choose>         
			<!-- Check for the presence of flickr.com in the string -->
           	<xsl:when test="not(contains($string, 'flickr.com'))"/>
           	 
           	<xsl:otherwise>         
           		<!-- We store the value of the string in the variable starting after the starting character of the required substring -->
            	<xsl:variable name="hrefString" select="substring-after($string, 'http://farm')"/>
           		<!-- We store the value of the string in the variable ending up to the final character of the required substring,
           			which is what the expected substring looks like -->
           	  	<xsl:variable name="hrefStringResult" select="substring-before($hrefString, '.jpg')"/>
           		<!-- We save the value of the remainder of the string in the variable -->
				<xsl:variable name="afterString" select="substring-after($string, '.jpg')"/>
										
           		<!-- Check for the presence in the substring of the required part of the address -->				
              	<xsl:if test="contains($hrefStringResult, 'flickr.com')">      
                   	 <p>                   	
                   	 	<xsl:text>http://farm</xsl:text>
                   		<xsl:value-of select="$hrefStringResult" disable-output-escaping="yes"/>
                   		<xsl:text>.jpg</xsl:text>                   	 	                  	 	
                   	</p>           
               	</xsl:if>       
               	
           		<!-- The recursive call with a new parameter value -->
               	<xsl:call-template name="findHref">            
                   	<xsl:with-param name="string" select="$afterString"/>  
               	</xsl:call-template>            

           	</xsl:otherwise>      
       	</xsl:choose>     
    </xsl:template> 
</xsl:stylesheet>


