<?php
$servername = "localhost";
$username   = "hubbuddi_271513_myTutoradmin";
$password   = "3c*49xKFaww^";
$dbname     = "hubbuddi_271513_myTutordb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

?>