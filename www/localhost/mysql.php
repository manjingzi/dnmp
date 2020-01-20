<?php

$link = mysqli_connect("mysql", "root", "123456");
if ($link) {
    echo 'OK';
} else {
    echo 'FAILD';
}