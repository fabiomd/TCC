(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (i64.rem_s  (local "g3228" i32)  (get_local $1)) (i64.ctz  (get_local $1)  (get_local $1)) (get_local $0)) )