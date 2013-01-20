<?php
$connect = mysql_connect("localhost","jeremysabath","$Am$0n94");
if (!$con)
   {
   die('Could not connect: ' . mysql_error());
   }

if (mysql_query("CREATE DATABASE OpenCity", $con))
   {
   echo "Database created";
   }
else
   {
   echo "Error creating database: " . mysql_error();
   }

mysql_close($con);
?>
