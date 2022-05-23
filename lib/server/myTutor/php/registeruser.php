<?php
include_once("dbconnect.php");
$username=$_POST['username'];
$phone_Num=$_POST['phoneNum'];
$address=$_POST['address'];
$email=$_POST['email'];
$password=$_POST['password'];
$userImage=$_POST['userImage'];
$passsha1=sha1($password);

$sqlregister="INSERT INTO tbl_users(username,phone_Num,address,email,password,userImage) VALUES('$username','$phone_Num','$address','$email','$passsha1','$userImage')";

if ($conn->query($sqlregister) === TRUE){
    echo "Success";

}else{
    echo "Failed";
}
?>