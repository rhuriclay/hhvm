<?hh

class NewClass {
  static public $a;
}

<<__EntryPoint>> function main(): void {
  print "Test begin\n";

  NewClass::$a = array(1,2,3);
  while (($b = array_pop(&NewClass::$a))) {
    echo $b . "\n";
    var_dump(NewClass::$a);
  }

  print "Test end\n";
}
