<?hh

class C<<<__Warn>> reify T> {}

function f<reify T>(T $x) {}
<<__EntryPoint>> function main(): void {
f<(C<int>)>(array(0 => new C<string>()));
f<(C<int>)>(array(3 => new C<string>()));
}
