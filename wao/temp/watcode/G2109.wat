(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (i64.shl  (f32.convert_s/i64   (f32.neg  (get_local $1)  (get_local $0)))  (get_local $0)) (get_local $0) (i32.add  (get_local $2)  (get_local $3))) )