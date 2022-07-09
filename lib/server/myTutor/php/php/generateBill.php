<?php
error_reporting(0);

$email = $_GET['email'];
$name = $_GET['name']; 
$phone = $_GET['phone']; 
$amount = $_GET['amount'];
$status="Order Confirmed";


$api_key='08bfa8ac-b29e-45c2-aa30-539da041c4f2';
$collection_id='yrdo9zch';
$host='https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'name'=> $name,
    'phone'=> $phone,
    'amount'=> $amount*100,
    'callback_url'=>"https://hubbuddies.com/271513/myTutor/php/return_url",
    'redirect_url'=>"https://hubbuddies.com/271513/myTutor/php/payment_update.php?email=$email&name=$name&phone=$phone&amount=$amount&status=$status",
    'description' => 'Payment for order by '.$name,
    );
    
$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) );

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

echo "<pre>".print_r($bill,true)."</pre>";
header("Location:{$bill['url']}");

?>