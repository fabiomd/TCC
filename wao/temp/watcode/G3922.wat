(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (f32.nearest  (get_local $0)  (get_local $1)) (i64.lt_u  (i64.ne  (get_local $0)  (i32.ne  (get_local $0)  (i64.rem_s  (get_local $0)  (get_local $0))))  (local "g3931" i32))) )