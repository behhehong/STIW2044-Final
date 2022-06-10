<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
//$results_per_page = 5;
//$pageno = (int)$_POST['pageno'];
//$search = $_POST['search'];

//$page_first_result = ($pageno - 1) * $results_per_page;
$sqlloadproduct = "SELECT * FROM tbl_subjects";
//$sqlloadproduct = "SELECT * FROM tbl_subjects WHERE subject_name LIKE //'%$search%' ORDER BY subject_id DESC";

$result = $conn->query($sqlloadproduct);
//$number_of_result = $result->num_rows;
//$number_of_page = ceil($number_of_result / $results_per_page);
//$sqlloadproduct = $sqlloadproduct . " LIMIT $page_first_result , //$results_per_page";
$result = $conn->query($sqlloadproduct);
if ($result->num_rows > 0) {
    //do something
    $products["products"] = array();
    while ($row = $result->fetch_assoc()) {
        $prlist = array();
        $prlist['subject_id'] = $row['subject_id'];
        $prlist['subject_name'] = $row['subject_name'];
        $prlist['subject_description'] = $row['subject_description'];
        $prlist['subject_price'] = $row['subject_price'];
        $prlist['tutor_id'] = $row['tutor_id'];
        $prlist['subject_sessions'] = $row['subject_sessions'];
        $prlist['subject_rating'] = $row['subject_rating'];
        array_push($products["products"],$prlist);
    }
    $response = array('status' => 'success', 'data' => $products);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed','data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>