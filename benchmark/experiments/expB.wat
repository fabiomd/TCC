(module
  (table 0 anyfunc)
  (memory $0 1)
  (export "memory" (memory $0))
  (export "divtwo" (func $divtwo))
  (func $divtwo (param $0 i32) (param $1 i32) (result i32)
    (local $2 i64)
    (local $3 i32)
    (set_local $2 (i32.convert_s/i64 (get_local $0)))
    (set_local $3 (i32.div
                      (get_local $1)
                      (i64.convert_s/i32 (get_local $2))
                  )
    )
    (get_local $3)
  )
)