<?php
if (!isset($_POST)) {
    $response = array('status' => 'Failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['email'];
$sqlloadcart = "SELECT cart_id, tbl_carts.subject_id AS subject_id, cart_qty, cart_status, receipt_id, cart_date, tbl_subjects.subject_name AS subject_name, tbl_subjects.subject_price AS subject_price FROM tbl_carts INNER JOIN tbl_subjects ON tbl_carts.subject_id = tbl_subjects.subject_id WHERE email = '$email' AND cart_status IS NULL";
$result = $conn->query($sqlloadcart);
$number_of_result = $result->num_rows;

if ($number_of_result > 0) {
    $total_payable = 0;
    $carts["carts"] = array();
    while ($row = $result -> fetch_assoc()) {
        $cartlist = array();
        $cartlist[cart_id] = $row['cart_id'];
        $cartlist[subject_id] = $row['subject_id'];
        $subjectprice = $row['subject_price'];
        $cartlist[cart_qty] = $row['cart_qty'];
        $cartlist[subject_price] = number_format((float)$subjectprice, 2, '.', '');
        $cartlist[cart_status] = $row['cart_status'];
        $cartlist[receipt_id] = $row['receipt_id'];
        $cartlist[cart_date] = $row['cart_date'];
        $cartlist[subject_name] = $row['subject_name'];
        $price = $row['cart_qty'] * $subjectprice;
        $total_payable = $total_payable + $price;
        $cartlist[pricetotal] = number_format((float)$price, 2, '.', '');
        array_push($carts["carts"],$cartlist);
    }
    $response = array('status' => 'success', 'data' => $carts, 'total' => $total_payable);
    sendJsonResponse($response);
    
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);

}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>