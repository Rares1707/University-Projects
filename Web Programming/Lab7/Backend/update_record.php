<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = $_POST['id'];
    $author = $_POST['author'];
    $title = $_POST['title'];
    $comment = $_POST['comment'];
    $datetime = $_POST['datetime'];

    require_once 'sqlConnection.php';
    $sqlCommand = "UPDATE `records` SET `author_email`='$author',`title`='$title',`comment`='$comment',`date`='$datetime' WHERE `id`='$id'";
    $databaseConnection = getDatabaseConnection();
    $response = $databaseConnection->query($sqlCommand);
    mysqli_close($databaseConnection);
    echo json_encode($response);
}
?>
