(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (get_local $1) (local "g2403" i64) (i64.clz  (f64.convert_u/i64   (f64.neg  (get_local $0)  (i64.convert_s/f64   (i64.div_s  (i64.rotl  (f64.convert_u/i64   (f64.floor  (local "g3616" f32)  (get_local $0)))  (get_local $1))  (f64.convert_u/i64   (f64.mul  (i32.convert_u/f64   (i32.xor  (f32.convert_u/i32   (f32.add  (get_local $0)  (get_local $0)))  (f64.convert_u/i32   (f64.max  (get_local $0)  (i32.convert_s/f64   (i32.le_s  (local "g3618" i64)  (i32.lt_s  (get_local $1)  (get_local $1))))))))  (get_local $1)))))))  (get_local $0))) )