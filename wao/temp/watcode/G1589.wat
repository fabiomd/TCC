(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (local $2 i32) (local $3 i32) (i32.eq  (get_local $1)  (f32.convert_u/i32   (f32.gt  (get_local $1)  (f32.le  (get_local $1)  (i64.convert_u/f32   (i64.le_s  (local "g1591" f32)  (i32.gt_s  (get_local $1)  (i32.gt_s  (f64.convert_u/i32   (f64.floor  (get_local $1)  (local "g1592" f64)))  (local "g1593" i64))))))))) (set_local $3  (get_local $1)) (i32.add  (get_local $2)  (get_local $3))) )