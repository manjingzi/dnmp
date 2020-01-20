<?php

$link = mysqli_connect("mysql", "root", "root");
if ($link) {
    echo 'OK';
} else {
    echo 'FAILD';
}