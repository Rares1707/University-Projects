<!-- this is an example by which I display the details from the table ana -->
<?php
//initialize the database connection 
$servername = "localhost";
$username = "root";
$password = ""; 
$dbname = "ana"; //the databasename

$conn = new mysqli($servername, $username, $password, $dbname); //This line of code creates a new mysqli object, which represents the connection to the MySQL database.

if ($conn->connect_error) {
    die("The connection not run: " . $conn->connect_error);
}

// Retrieve the data submitted by the form
$nume = $_POST['nume'];
$descriere = $_POST['descriere'];
$pret = $_POST['pret'];
$directOnly = isset($_POST['direct_only']);

// Retrieve the data submitted by the form
$sql = "SELECT * FROM produse";
$result = $conn->query($sql);

// Display the products
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
  // Display the product attributes
        echo "Product name: " . $row['nume'] . "<br>";
        echo "About: " . $row['descriere'] . "<br>";
        echo "Price: " . $row['pret'] . "<br>";
        echo "<br>";
    }
} else {
    echo "The products doesn't exist";
}
?>
