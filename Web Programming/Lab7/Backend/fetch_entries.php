<?php

if ($_SERVER['REQUEST_METHOD'] == 'GET')
{
    $page = $_GET['page']; 
    $sortingType = NULL;
    if (isset($_GET['sortingType']))
    {
        $sortingType = $_GET['sortingType'];
    }
    $maximumEntriesOnPage = 4; 
    $offset = ($page - 1) * $maximumEntriesOnPage;

    require_once 'sqlConnection.php';
    if ($sortingType == NULL)
    {
        $sqlCommand = "SELECT * FROM `records` ORDER BY `id` ASC LIMIT $offset, $maximumEntriesOnPage";
    }
    else if ($sortingType == 'byTitle')
    {
        $sqlCommand = "SELECT * FROM `records` ORDER BY `title` ASC LIMIT $offset, $maximumEntriesOnPage";
    }
    else if ($sortingType == 'byAuthor')
    {
        $sqlCommand = "SELECT * FROM `records` ORDER BY `author_email` ASC LIMIT $offset, $maximumEntriesOnPage";
    }
    $databaseConnection = getDatabaseConnection();
    $result = $databaseConnection->query($sqlCommand);

    $myArray = array();

    while ($row = $result->fetch_assoc()) {
        $myArray[] = $row;
    }

    echo json_encode($myArray);
}   
?>
