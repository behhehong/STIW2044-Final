<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/hubbuddi/public_html/271513/myTutor/php/PHPMailer/Exception.php';
require '/home8/hubbuddi/public_html/271513/myTutor/php/PHPMailer/PHPMailer.php';
require '/home8/hubbuddi/public_html/271513/myTutor/php/PHPMailer/SMTP.php';


include_once("dbconnect.php");


$email = $_POST['email'];
$otp = rand(000001,999999);
$newpass = random_password(10);
$passha = sha1($newpass);

$sql = "SELECT * FROM tbl_users WHERE email = '$email'";

$result = $conn->query($sql);

if($result->num_rows>0){
    $sqlupdate= "UPDATE tbl_users SET otp = '$otp', password = '$passha' WHERE email = '$email'";
    if($conn->query($sqlupdate)===TRUE){
        sendEmail($otp,$newpass,$email);
        echo "success";
    }else{
        echo "reset failed";
    }
}
else{
    echo "no user";
}


function sendEmail($otp,$newpass,$email){
 $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                           //Disable verbose debug output
    $mail->isSMTP();                                //Send using SMTP
    $mail->Host       = 'mail.hubbuddies.com';      //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                       //Enable SMTP authentication
    $mail->Username   = 'mytutor@hubbuddies.com';                         //SMTP username
    $mail->Password   = 'kkH%Y(t6]p[z';                       //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "mytutor@hubbuddies.com";
    $to = $email;
    $subject = "Reset your account";
    $message = "<p>Your account has been reset. Please click the button bellow to verify your account before login again using the information below.</p><br><br><h3>Password:".$newpass.
    "</h3><br><br>Please <a href='https://hubbuddies.com/271513/myTutor/php/verifyaccount.php?email=".$email."&key=".$otp."'>Click Here</a> to verify your account.";
    
    $mail->setFrom($from,"MyTutor");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

function random_password($length){
    //A list of characters that can be used in our
    //random password.
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    //Create a blank string.
    $password = '';
    //Get the index of the last character in our $characters string.
    $characterListLength = mb_strlen($characters, '8bit') - 1;
    //Loop from 1 to the $length that was specified.
    foreach(range(1, $length) as $i){
        $password .= $characters[rand(0, $characterListLength)];
    }
    return $password;
}

?>