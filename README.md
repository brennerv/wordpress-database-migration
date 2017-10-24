# wordpress-database-migration
An example of using the transformation of an exported Wordpress database in instructions to populate a new Wordpress 
version database.<br>
Tested on version Wordpress 2.8.<br>

"wp_db_transformation.xsl"<br>

Example of application:<br>
  You need to export the old Wordpress database to the "xml" format using, for example, "phpMyAdmin".<br>
  In the XSL specify a new desired path to the images.<br>
  Apply XSL transformation to "xml" file.<br>
  

"db_get_all_images_links.xsl"	<br>
"db_get_all_images_addresses.xsl"<br>

Example of application:<br>
  You need to export the old Wordpress database to the "xml" format using, for example, "phpMyAdmin".<br>
  Apply XSL transformation to "xml" file.<br>
