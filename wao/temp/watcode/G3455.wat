(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (local $3 i32) (i32.and  (local "g3456" f64)  (get_local $0)) (set_local $3  (get_local $1)) (i32.add  (get_local $2)  (get_local $3))) )