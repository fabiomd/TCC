(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (local $2 i32) (local $3 i32) (set_local $2  (get_local $0)) (f64.ne  (local "g929" i64)  (f64.sub  (f64.ne  (get_local $1)  (local "g930" f32))  (get_local $0))) (i32.add  (get_local $2)  (get_local $3))) )