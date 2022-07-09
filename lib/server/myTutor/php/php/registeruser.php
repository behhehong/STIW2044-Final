<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/hubbuddi/public_html/270607/snackeverywhere/php/PHPMailer/Exception.php';
require '/home8/hubbuddi/public_html/270607/snackeverywhere/php/PHPMailer/PHPMailer.php';
require '/home8/hubbuddi/public_html/270607/snackeverywhere/php/PHPMailer/SMTP.php';

if (!isset($_POST)) {
    $response = array('status' => 'Failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$username=$_POST['username'];
$phoneNum=$_POST['phoneNum'];
$address=$_POST['address'];
$otp = rand(100000,999999);
$email=$_POST['email'];
$password=$_POST['password'];
$passsha1=sha1($password);
$base64image = $_POST['image'];

$sqlinsert="INSERT INTO tbl_users(username, phoneNum, address, email, password, otp) VALUES ('$username','$phoneNum','$address','$email','$passsha1', '$otp')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../assets/profilepic/' . $filename . '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
    sendEmail($username,$email,$otp);
    sendJsonResponse($response);

}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

function sendEmail($username,$email,$otp){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0; //Disable verbose debug output
    $mail->isSMTP(); //Send using SMTP
    $mail->Host= 'mail.hubbuddies.com'; //Set the SMTP server to send through
    $mail->SMTPAuth= true; //Enable SMTP authentication
    $mail->Username= 'mytutor@hubbuddies.com'; //SMTP username
    $mail->Password= 'kkH%Y(t6]p[z'; //SMTP password
    $mail->SMTPSecure= 'tls';         
    $mail->Port= 587;
    
    $from = "mytutor@hubbuddies.com";
    $to = $email;
    $subject = "Account Verification";
    $message = "Hi $username,<br><br>
    
	            Welcome to MyTutor! Your account has been successfully created!<br><br>
	            
                Your username is the email you registered with: $email. 
                Please <a href='https://hubbuddies.com/271513/myTutor/php/verifyaccount.php?email=".$email."&key=".$otp."'>Click Here</a> to verify your account.<br><br><br><br><br><br><br><br><br><br><br><br>
                
                
                
                
                
                You have been sent this email because an account was created on MyTutor with the email address <u>$email</u><br>
                If you have received it in error, please ignore this email.";
    
    $mail->setFrom($from,"MyTutor");
    $mail->addAddress($to);//Add a recipient
    
    //Content
    $mail->isHTML(true);//Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}
?>