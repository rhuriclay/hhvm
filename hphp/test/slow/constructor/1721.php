<?php

class A {
  public function A() {
    echo "In A\n";
    $this->__construct();
  }
  public function __construct() {
    echo "In A::__construct\n";
  }
}
class B extends A {
  public function B() {
    echo "In B\n";
    $this->A();
  }
}
class A2 {
  public function __construct() {
    echo "In A2::__construct\n";
    $this->B2();
  }
  public function B2() {
    echo "In B2\n";
  }
}
class B2 extends A2 {
  public function __construct() {
    echo "In B2::__construct\n";
    parent::__construct();
  }
}
class C {
  public function C() {
}
}
class D extends C {
  public function __construct() {
    echo "In D::__construct\n";
    C::__construct();
  }
}
class E {
  public function E() {
    echo "In E\n";
  }
  public function foo() {
    $this->E();
    E::__construct();
  }
}

<<__EntryPoint>>
function main_1721() {
$obj = new B();
$obj = new B2();
$obj = new D;
$obj->c();
$obj = new E;
$obj->foo();
}
