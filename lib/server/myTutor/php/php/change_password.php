<?php

include_once("dbconnect.php");

$email = $_POST['email'];
$currentPassword = $_POST['currentPassword'];
$currsha1 = sha1($currentPassword);
$password = $_POST['password'];
$passha1 = sha1($password);
$notFound = false;

$sqlsearch = "SELECT * FROM tbl_users WHERE email = '$email'";
$result = $conn->query($sqlsearch);
if ($result->num_rows > 0){
    while ($row = $result->fetch_assoc()) {
        $userpassword = $row['password'];
     }
     if ($currsha1 != $userpassword ) {
         echo "WrongCurrPass";
     }
     else {
        $sqlupdate = "UPDATE tbl_users SET password = '$passha1' WHERE email = '$email'";
        
     }
    
}else{
    $notFound = true;
}
    
if($conn->query($sqlupdate) === TRUE){
    
    echo "Success";
}else if($notFound == true){
    
    echo "NotFound";
    
}else{
    echo "Failed";
}

?>