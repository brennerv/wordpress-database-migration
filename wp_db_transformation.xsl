<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" encoding="UTF-8" indent="yes"/>
	
	<!-- Can be changed -->
  <!-- New path for images -->
	<xsl:variable name="newHrefString">http://192.168.100.21/images/</xsl:variable>
	
	<!-- Example: transformation for the new Waordpress 2.8 -->
	<xsl:template match="/">
	-- 
	-- DB: `wp28`
	-- 
	
	-- --------------------------------------------------------
	
	-- 
	-- Updating table data `wp_posts`
	-- 
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>

 	<xsl:template match="wp_posts">
 		<xsl:variable name="postContent"> 			
	 		<!-- Calling a template with parameter passing with a node value "post_content" -->
			<xsl:apply-templates select="post_content"/>    
        </xsl:variable>
        <!-- Output of sql-commands with changed node content "post_content" -->
  		<xsl:variable name="sqlContent"> 			
			UPDATE wp_posts SET   post_author 			= <xsl:value-of select="post_author"/>, 
								  post_date 			= '<xsl:value-of select="post_date"/>', 
								  post_date_gmt 		= '<xsl:value-of select="post_date_gmt"/>', 
								  post_content 			= '<xsl:value-of select="$postContent"/>', 
								  post_title 			= '<xsl:value-of select="post_title"/>', 
								  post_category 		= <xsl:value-of select="post_category"/>, 
								  post_excerpt 			= '<xsl:value-of select="post_excerpt"/>',
								  post_status 			= '<xsl:value-of select="post_status"/>',
								  comment_status 		= '<xsl:value-of select="comment_status"/>', 
								  ping_status 			= '<xsl:value-of select="ping_status"/>', 
								  post_password 		= '<xsl:value-of select="post_password"/>', 
								  post_name 			= '<xsl:value-of select="post_name"/>', 
								  to_ping 				= '<xsl:value-of select="to_ping"/>', 
								  pinged 				= '<xsl:value-of select="pinged"/>', 
								  post_modified 		= '<xsl:value-of select="post_modified"/>', 
								  post_modified_gmt 	= '<xsl:value-of select="post_modified_gmt"/>', 
								  post_content_filtered = '<xsl:value-of select="post_content_filtered"/>', 
								  post_parent 			= <xsl:value-of select="post_parent"/>, 
								  guid 					= '<xsl:value-of select="guid"/>', 
								  menu_order 			= <xsl:value-of select="menu_order"/>, 
								  post_type 			= '<xsl:value-of select="post_type"/>', 
								  post_mime_type 		= '<xsl:value-of select="post_mime_type"/>', 
								  comment_count 		= <xsl:value-of select="comment_count"/>
							WHERE ID = <xsl:value-of select="ID"/>;
        </xsl:variable>
        <xsl:value-of select="normalize-space($sqlContent)"/>
	</xsl:template>

	<!-- Template for node transformation "post_content" -->
 	<xsl:template match="wp_posts/post_content"> 		
 		<xsl:variable name="step1"> 			
	 		<!-- Calling a template with parameter passing with a value of current node -->
			<xsl:call-template name="findHrefAndDelete">
	           	<xsl:with-param name="string" select="."/>
	        </xsl:call-template>    
        </xsl:variable>
  		<xsl:variable name="step2"> 			
	  		<!-- Calling a template with parameter passing with a value of $step1 -->
			<xsl:call-template name="findHrefAndRenew">
	          	<xsl:with-param name="string" select="$step1"/>
	        </xsl:call-template>    
         </xsl:variable>
  		<xsl:variable name="step3">		
	 		<!-- Calling a template with parameter passing with a value of $step2 -->
			<xsl:call-template name="findImgAndRenewHref">
	           	<xsl:with-param name="string" select="$step2"/>
	        </xsl:call-template>    
         </xsl:variable>	     
         <!-- Replacing the character &#xA; to \r\n -->
         <xsl:variable name="step4">  	
			<xsl:call-template name="findCodeAndReplace">
	           	<xsl:with-param name="string" select="$step3"/>
	           	<xsl:with-param name="search-for" select="'&#xA;'"/>
		  		<xsl:with-param name="replace-with">  
		    		<xsl:text>\r\n</xsl:text>  
		  		</xsl:with-param>
  			</xsl:call-template>    		
	    </xsl:variable>

	    <xsl:value-of select="$step4"/>
  	</xsl:template>
	
	<!-- Recursive search for substrings &lt;em&gt; (<em>)  &lt;/em&gt; (</em>)  and deleting -->
    <xsl:template name="findHrefAndDelete">
    	<xsl:param name="string"/>    	 
        
		<xsl:choose>         
           	<!-- Check for the presence of flickr.com in the line -->
           	<xsl:when test="not(contains($string, 'flickr.com'))">
           		<xsl:value-of select="$string"/>  
           	</xsl:when>
           	<!-- Check for &lt;em&gt; in line -->
           	<xsl:when test="not(contains($string, '&lt;em&gt;'))">
           		<xsl:value-of select="$string"/>  
           	</xsl:when>
           	 
           	<!-- If the string contains the required substring, then we continue the recursion, otherwise we exit the recursion -->
           	<xsl:otherwise>    
           		<!-- Display text that does not contain references, which is before &lt;em&gt; -->
           		<xsl:value-of select="substring-before($string, '&lt;em&gt;')"/> 
           		    
           		<!-- We store the value of the string in the variable beginning after the starting character of the required substring -->
            	<xsl:variable name="hrefString" select="substring-after($string, '&lt;em&gt;')"/>
            	<!-- We save the value of the string to the variable ending up to the final character of the required substring, which is the result of the substring -->
           	  	<xsl:variable name="hrefStringResult" select="substring-before($hrefString, '&lt;/em&gt;')"/>
           	  	<!-- We store the value in the variable of the rest of the line -->
				<xsl:variable name="afterString" select="substring-after($hrefString, '&lt;/em&gt;')"/>
				
				<!-- Check for the presence in the found substring of the required part of the address.
					 If there are coincidences, then replace the text, otherwise we print the text to the main stream without changes. -->
				<xsl:choose>         		    
           			<xsl:when test="contains($hrefStringResult, 'flickr.com')"> 
           			</xsl:when>
           			<xsl:otherwise>
                    	<xsl:text>&lt;em&gt;</xsl:text>
                   			<xsl:value-of select="$hrefStringResult"/>                   			
                   	 	<xsl:text>&lt;/em&gt;</xsl:text>    
           			</xsl:otherwise>      
       			</xsl:choose>              
				
				<!-- A recursive call with a new parameter value. -->
               	<xsl:call-template name="findHrefAndDelete">            
                   	<xsl:with-param name="string" select="$afterString"/>   
               	</xsl:call-template>            

           	</xsl:otherwise>      
       	</xsl:choose>       
    </xsl:template> 

	<!-- Recursive search for substrings and replacement for a new line. -->
    <xsl:template name="findHrefAndRenew">
    	<xsl:param name="string"/>    	   
        
		<xsl:choose>         
           	<!-- Check for the presence of flickr.com in the line -->
           	<xsl:when test="not(contains($string, 'www.flickr.com'))">
           		<xsl:value-of select="$string"/>  
           	</xsl:when>
           	<!-- Check for &lt;a in the line -->
           	<xsl:when test="not(contains($string, '&lt;a'))">
           		<xsl:value-of select="$string"/>  
           	</xsl:when>
           	 
           	<!-- If the string contains the required substring, then we continue the recursion, otherwise we exit the recursion -->
           	<xsl:otherwise>    
           		<!-- Output text that does not contain references, which is before &lt;a -->
           		<xsl:value-of select="substring-before($string, '&lt;a')"/> 
           		    
           		<!-- We store the value of the string in the variable beginning after the starting character of the required substring -->
            	<xsl:variable name="hrefString" select="substring-after($string, '&lt;a')"/>
            	<!-- We store the value of the string in the variable ending up to the final character of the required substring, which is the substring sought as a result -->
           	  	<xsl:variable name="hrefStringResult" select="substring-before($hrefString, '/a&gt;')"/>
           	  	<!-- We store the value in the variable of the rest of the line -->
				<xsl:variable name="afterString" select="substring-after($hrefString, '/a&gt;')"/>
				
				<!-- Check for the presence in the found substring of the required part of the address.
					 If there are coincidences, then we replace the address with a new address, otherwise we print the text to the main stream without changes -->
				<xsl:choose>         		    
           			<xsl:when test="contains($hrefStringResult, 'flickr.com')">            					           						
            			<!-- Select the attribute "img" from the found line -->            			
            				<xsl:variable name="img" select="substring-after($hrefStringResult, '&lt;img')"/>
           	  				<xsl:variable name="imgResult" select="substring-before($img, '/&gt;')"/>
           	  			           	  			           	  			          				
            			<!-- Text output -->   
                  			<xsl:text>&lt;img </xsl:text>
                  				<xsl:value-of select="$imgResult" disable-output-escaping="no"/>
                  			<xsl:text> /&gt;</xsl:text>
           			</xsl:when>
           			<xsl:otherwise>
                    	<xsl:text>&lt;a</xsl:text>
                   			<xsl:value-of select="$hrefStringResult"/>                   			
                   	 	<xsl:text>/a&gt;</xsl:text> 
           			</xsl:otherwise>      
       			</xsl:choose>              
				
				<!-- Recursive call with new parameter value -->
               	<xsl:call-template name="findHrefAndRenew">            
                   	<xsl:with-param name="string" select="$afterString"/>   
               	</xsl:call-template>            

           	</xsl:otherwise>      
       	</xsl:choose>       
    </xsl:template> 

	<!-- Recursive search for substrings and replacement by a new line -->
    <xsl:template name="findImgAndRenewHref">
    	<xsl:param name="string"/>
    	
		<xsl:choose>         
           	<!-- Check for the presence of flickr.com in the line -->
           	<xsl:when test="not(contains($string, 'flickr.com'))">
           		<xsl:value-of select="$string"/>
           	</xsl:when> 
           	<!-- If the string contains the required substring, then we continue the recursion, otherwise we exit the recursion -->
           	<xsl:otherwise>    
           		<!-- Display text that does not contain links, which is before http://farm -->
           		<xsl:value-of select="substring-before($string, 'http://farm')"/> 
           		    
           		<!-- We store the value of the string in the variable starting after the http://farm character of the required substring -->
            	<xsl:variable name="hrefString" select="substring-after($string, 'http://farm')"/>
            	<!-- Save the value in the file name variable to the point that is the required substring as a result, and add the characters '.jpg' -->
           	  	<xsl:variable name="hrefStringResult" select="concat(substring-before($hrefString, '.jpg'), '.jpg')"/>
           	  	<!-- Save the value in the variable of the rest of the line -->
				<xsl:variable name="afterString" select="substring-after($hrefString, '.jpg')"/>
								         		
            	<!-- Select the name of the image from the found "hrefStringResult" string -->
           		<xsl:variable name="jpg" select="substring-after($hrefStringResult, 'flickr.com/')"/>
           		<xsl:variable name="jpgNameResult" select="substring-after($jpg, '/')"/>
          		<!-- Add a new address to the name of the picture -->
           		<xsl:variable name="newJpgLinkResult" select="concat($newHrefString, $jpgNameResult)"/>
           	  			           	  			           	  			          				
            	<!-- Text output -->
                <xsl:value-of select="$newJpgLinkResult"/>        			             
				
				<!-- Recursive call with new parameter value -->
               	<xsl:call-template name="findImgAndRenewHref">            
                   	<xsl:with-param name="string" select="$afterString"/>   
               	</xsl:call-template>            

           	</xsl:otherwise>      
       	</xsl:choose>  
    </xsl:template> 
    
	<!-- The function to replace a substring with a new one -->
	<xsl:template name="findCodeAndReplace">
  		<xsl:param name="string" select="."/>
  		<xsl:param name="search-for" select="''"/>
  		<xsl:param name="replace-with" select="''"/>
  		
  		<xsl:choose>
    		<xsl:when test="contains($string, $search-for)">
      			<xsl:value-of select="substring-before($string, $search-for)"/>
      			<xsl:copy-of select="$replace-with"/>
      			<xsl:call-template name="findCodeAndReplace">
        			<xsl:with-param name="string" select="substring-after($string, $search-for)"/>
        			<xsl:with-param name="search-for" select="$search-for"/>
        			<xsl:with-param name="replace-with" select="$replace-with"/>
      			</xsl:call-template>
    		</xsl:when>
    		<xsl:otherwise>
      			<xsl:value-of select="$string"/>
    		</xsl:otherwise>
  		</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>
