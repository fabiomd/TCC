(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (local $2 i32) (local $3 i32) (set_local $2  (get_local $0)) (set_local $3  (get_local $1)) (i64.gt_s  (local "g847" i32)  (f64.convert_u/i64   (f64.lt  (get_local $1)  (i64.convert_s/f64   (i64.div_s  (if  (i64.le_u  (local "g848" i64)  (get_local $0))   (f32.convert_s/i64   (f32.sub  (local "g850" f64)  (get_local $0)))   (local "g851" f64))  (f32.convert_u/i64   (f32.ceil  (local "g855" i32)  (local "g856" f64))))))))) )