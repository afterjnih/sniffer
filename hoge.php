<?php
  // $file = file_get_contents("/Users/koji/bin/phpcs/CodeSniffer/Standards/Zend/Sniffs/NamingConventions/ValidVariableNameSniff.php");
  // $tokens = token_get_all($file);
  // print_r(json_encode($tokens));
error_reporting(0);

  $xml = simplexml_load_file('/Users/koji/bin/phpcs/CodeSniffer/Standards/Zend/ruleset.xml');
  
  $snifferFiles = array();
  foreach ($xml->rule as $rule) {
    if (count(explode(".", $rule->attributes())) == 3) {
      $fileArray = explode(".", $rule->attributes());
      $fileName = "/Users/koji/bin/phpcs/CodeSniffer/Standards/"
      . $fileArray[0] . "/"
      . "Sniffs/"
      . $fileArray[1] . "/"
      . $fileArray[2] . "Sniff.php";
      array_push($snifferFiles, $fileName);
    }
  }

  getSnifferfile("/Users/koji/bin/phpcs/CodeSniffer/Standards/Zend/Sniffs");

  $tokenArray = array();
  foreach($snifferFiles as $snifferFile) {
    $file = file_get_contents($snifferFile);
    $tokens = token_get_all($file);
    // array_push($tokenArray, $tokens);
    // print_r(array(getSnifferName($sniffeFile), $tokens));
    $tmpArr = array();
    // array_push($tokenArray, $tokens);
    // $tmpArr[getSnifferName($snifferFiles)]
    // print_r(getSnifferName($snifferFile));
    // print_r("\n");
    $tmpArr[getSnifferName($snifferFile)] = $tokens;
    // array_push($tokenArray, array(getSnifferName($snifferFile), $tokens));
    // print_r($tmpArr);
    array_push($tokenArray, $tmpArr);
  }
  print_r(json_encode($tokenArray));

  // getSnifferfile("/Users/koji/bin/phpcs/CodeSniffer/Standards/Zend/Sniffs");
  function getSnifferfile($directory)
  {
    global $snifferFiles;
    $files = scandir($directory);
    if ($files != null) {
      foreach($files as $file){
        if ($file  == "." || $file == ".."){
        }else{
          getSnifferfile($directory . "/" . $file);
        }
      }
    } else {
      array_push($snifferFiles, $directory);
    }
  }

  function getSnifferName($snifferFile) {
    $sniffFileNameArr = explode("/", $snifferFile);
    $count = count($sniffFileNameArr);
    $name = $sniffFileNameArr[$count - 4] . "." . $sniffFileNameArr[$count - 2] . "." . explode("Sniff.php", $sniffFileNameArr[$count -1])[0];
    return $name;
  }
