(module (table 0 anyfunc) (memory $0 1) (export "memory" (memory $0)) (export "sumtwo" (func $sumtwo)) (func $sumtwo (param $0 i32) (param $1 i32) (result i32)  (local $2 i32) (i64.xor  (f64.convert_s/i64   (f64.gt  (i64.convert_s/f64   (i64.div_s  (i64.eqz  (local "g2359" f32)  (i32.xor  (f32.convert_u/i32   (f32.add  (f32.sub  (f64.trunc  (local "g2360" f32)  (get_local $0))  (f32.add  (get_local $1)  (i32.convert_u/f32   (i32.shl  (f64.convert_s/i32   (f64.floor  (i32.convert_s/f64   (i32.or  (get_local $1)  (get_local $1)))  (local "g2361" i32)))  (get_local $0)))))  (get_local $1)))  (get_local $0)))  (get_local $1)))  (get_local $0)))  (local "g2363" i64)) (set_local $2  (get_local $0)) (set_local $3  (get_local $1)) (i32.add  (get_local $2)  (get_local $3))) )