<?php

class pass {
    private static function show() {
        echo "Call show()\n";
    }

    public static function do_show() {
        pass::show();
    }
}
<<__EntryPoint>> function main() {
pass::do_show();
pass::show();

echo "Done\n"; // shouldn't be displayed
}
