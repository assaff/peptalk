<?php
require 'Console/Getargs.php';

$username = 'assaff';
$secret = 'Mv2wSeRvznUXD29F5FH7';
$api_address = 'http://genomics9.bu.edu:8090/api.php';

$config = array(
      'protein' => array(
            'short' => 'p',
            'max'  => '1',
            'desc' => 'Protein file'),
      'protpdb' => array(
            'short' => 'pp',
            'max'  => '1',
            'desc' => 'Protein pdb id'),
      'protmask' => array(
            'short' => 'pm',
            'max'  => '1',
            'desc' => 'Protein mask'),
      'jobname' => array(
            'short' => 'j',
            'min'  => '1',
            'max'  => '1',
            'desc' => 'Job name'),
      'protchains' => array(
            'short' => 'pc',
            'max'  => '-1',
            'desc' => 'Chains for protein'),
      'pbmode' => array(
            'short' => 'pb',
            'max'  => '1',
            'desc' => 'PB mode'),
      'ppimode' => array(
            'short' => 'ppi',
            'max'  => '0',
            'desc' => 'Use PPI mode'),
      );

$args =& Console_Getargs::factory($config);
if (PEAR::isError($args)) {
    $header = 'Usage: '.basename($_SERVER['SCRIPT_NAME'])." [options]\n\n";
    if ($args->getCode() === CONSOLE_GETARGS_ERROR_USER) {
        echo Console_Getargs::getHelp($config, $header, $args->getMessage())."\n";
    } else if ($args->getCode() === CONSOLE_GETARGS_HELP) {
        echo Console_Getargs::getHelp($config, $header)."\n";
        // To see the automatic header uncomment this line
        //echo Console_Getargs::getHelp($config)."\n";
    }
    exit;
}

$form = array_map('trim', $args->_longLong);
$errors = array();

$form['username'] = $username;
if ( isset($form['protein']) && ! is_readable($form['protein']) )
{
	$errors[] = 'Protein file not found';
}
if ( isset($form['protmask']) && ! is_readable($form['protmask']) )
{
	$errors[] = 'Protein mask file not found';
}
if ( ! ( isset($form['protein']) || isset($form['protpdb']) ) )
{
	$errors[] = 'No protein specified';
}
if (  isset($form['protein']) && isset($form['protpdb']) )
{
	$errors[] = 'Please only specify a protein or protein pdb id';
}

if ( sizeof($errors) > 0 )
{
    print_r($errors);
    exit(1);
}

if ( isset($form['protein']) )
{
    $form['useprotpdbid'] = '0';
} else {
    $form['useprotpdbid'] = '1';
}

$keys = array_keys($form);
    
sort($keys, SORT_STRING);
$sig_string = '';
foreach ($keys as $key) {
        $sig_string .= $key . $form[$key];
}

$form['sig'] = hash_hmac('md5', $sig_string, $secret);

$request = new HttpRequest($api_address,  HTTP_METH_POST);

$request->addPostFields($form);

if (isset($form['protein'])) {
    $request->addPostFile('prot', $form['protein']);
}
if (isset($form['protmask'])) {
    $request->addPostFile('protmask', $form['protmask']);
}

$request->send();

if ($request->getResponseCode() != 200) {
    $response_body = json_decode($request->getResponseBody());
    foreach ($response_body->errors AS $error) {
        echo $error, "\n";
    }
    exit(1);
} else {
    $response_body = json_decode($request->getResponseBody());
    echo $response_body->id, "\n";
}
