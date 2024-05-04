<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $entryId = $_POST['entry_id'];

    require_once 'sqlConnection.php';
    $sqlCommand = "DELETE FROM `records` WHERE `id` = $entryId";
    $databaseConnection = getDatabaseConnection();
    $response =  $databaseConnection->query($sqlCommand);
    mysqli_close($databaseConnection);
    echo json_encode($response);
}
?>
