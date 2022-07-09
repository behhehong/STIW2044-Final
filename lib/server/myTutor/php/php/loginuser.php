<?php
if (!isset($_POST)) {
    $response = array('status' => 'Failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM tbl_users WHERE email = '$email' AND password = '$password' AND otp = '0'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $user['userId'] = $row['userId'];
        $user['username'] = $row['username'];
        $user['phoneNum'] = $row['phoneNum'];
        $user['address'] = $row['address'];
        $user['email'] = $row['email'];
        $user['date_reg'] = $row['date_Register'];
    }
    $sqlgetqty = "SELECT * FROM tbl_carts WHERE email = '$email' AND cart_status IS NULL";
    $result = $conn->query($sqlgetqty);
    $number_of_result = $result->num_rows;
    $carttotal = 0;
    while($row = $result->fetch_assoc()) {
        $carttotal = $row['cart_qty'] + $carttotal;
    }
    $mycart = array();
    $user['cart'] =$carttotal;
    
    $response = array('status' => 'Success', 'data' => $user);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'Failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>