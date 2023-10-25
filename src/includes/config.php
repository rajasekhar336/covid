  ?>
<?php
$host = '172.31.33.119'; // MySQL host (replace with your actual host)
$username = 'root'; // MySQL username
$password = 'rajasekhar'; // MySQL password
$database = 'covidtmsdb'; // MySQL database name

// Create a database connection
$connection = new mysqli($host, $username, $password, $database);

// Check the connection
if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}
