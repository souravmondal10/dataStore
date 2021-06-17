<?php
require_once __DIR__ . '/config.php';
$redis = new Redis();
$redis->connect(REDIS_HOST, REDIS_PORT);
$con = connectDatabase();
if (!$con) {
    die("Can not connect to database");
}

while(true){
    $allKeys = $redis->keys('*');
    $allUsersData = [];
    foreach ($allKeys as $singleKeys) {
        $singleUserData = json_decode($redis->get($singleKeys));
        $userId = str_replace('user_object_', '', $singleKeys);
        echo $sql = "INSERT INTO `users` (`userId`, `username`, `useremail`) VALUES ('$userId','$singleUserData->username', '$singleUserData->useremail')";
        $result = mysqli_query($con, $sql);
        $redis->del($singleKeys);
    }
    $output_string = 'cron processed at - '.date('dd-mm-yyyy H:i:s').PHP_EOL;
    file_put_contents('./process_output.log', $output_string, FILE_APPEND);
    sleep(30);
}


function connectDatabase()
{
    $con = mysqli_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, MYSQL_PORT);
    // Check connection
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
        return false;
    }
    return $con;
}

