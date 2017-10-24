# wordpress-database-migration
An example of using the transformation of an exported Wordpress database in instructions to populate a new Wordpress 
version database. 
Tested on version Wordpress 2.8.

"wp_db_transformation.xsl"

Example of application:
  You need to export the old Wordpress database to the "xml" format using, for example, "phpMyAdmin".
  In the XSL specify a new desired path to the images.
  Apply XSL transformation to "xml" file.
  

"db_get_all_images_links.xsl"
"db_get_all_images_addresses.xsl"

Example of application:
  You need to export the old Wordpress database to the "xml" format using, for example, "phpMyAdmin".
  Apply XSL transformation to "xml" file.
