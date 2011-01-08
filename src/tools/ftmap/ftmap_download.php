<?php
require 'Console/Getargs.php';
$username = 'assaff';
$secret = 'Mv2wSeRvznUXD29F5FH7';
$api_address = 'http://genomics9.bu.edu:8090/api_download.php';

$config = array(
      'jobid' => array(
            'short' => 'j',
            'min'  => '1',
            'max'  => '1',
            'desc' => 'Job id'),
      );

$args =& Console_Getargs::factory($config);
if (PEAR::isError($args)) {
    $header = 'Usage: '.basename($_SERVER['SCRIPT_NAME'])." [options]\n\n";
    if ($args->getCode() === CONSOLE_GETARGS_ERROR_USER) {
        echo Console_Getargs::getHelp($config, $header)."\n".$args->getMessage()."\n";
    } else if ($args->getCode() === CONSOLE_GETARGS_HELP) {
        echo Console_Getargs::getHelp($config, $header)."\n";
        // To see the automatic header uncomment this line
        //echo Console_Getargs::getHelp($config)."\n";
    }
    exit;
}

$form = array_map('trim', $args->_longLong);

$form['username'] = $username;
//print_r($form);

$keys = array_keys($form);
    
sort($keys, SORT_STRING);
$sig_string = '';
foreach ($keys as $key) {
        $sig_string .= $key . $form[$key];
}

$form['sig'] = hash_hmac('md5', $sig_string, $secret);

$request = new HttpRequest($api_address,  HTTP_METH_POST);

$request->addPostFields($form);

$request->send();

if ($request->getResponseCode() != 200) {
    $response_body = json_decode($request->getResponseBody());
    foreach ($response_body->errors AS $error) {
        echo $error, "\n";
    }
    exit(1);
} else {
    file_put_contents('ftmap.'.$form['jobid'].'.pdb.gz', $request->getResponseBody());
}
