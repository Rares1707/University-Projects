<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $author = $_POST['author'];
    $title = $_POST['title'];
    $comment = $_POST['comment'];

    require_once 'sqlConnection.php';
    $sqlCommand = "INSERT INTO `records` (`author_email`, `title`, `comment`, `date`) VALUES ('$author', '$title', '$comment', NOW())";
    $databaseConnection = getDatabaseConnection();
    $response = $databaseConnection->query($sqlCommand);
    mysqli_close($databaseConnection);
    echo json_encode($response);
}
?>
