<?php
    function getDatabaseConnection()
    {
        $database_host = 'localhost';
        $database_username = 'root';
        $database_password = '';
        $database_name = 'guestbook';
        
        $database_connection = mysqli_connect(
            $database_host,
            $database_username,
            $database_password,
            $database_name
        );

        if (!$database_connection)
            die("Connection to database failed: " . mysqli_connect_error());
        
        return $database_connection;
    }
?>