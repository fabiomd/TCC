(module
  (table 0 anyfunc)
  (memory $0 1)
  (export "memory" (memory $0))
  (export "multwo" (func $multwo))
  (func $multwo (param $0 i32) (param $1 i32) (result i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $3 (get_local $1))
    (set_local $2 (i32.mul (get_local $0) (get_local $3)))
    (if (result i32)
      (i32.lt_s
         (get_local $2)
         (get_local $3)
      )
      (then
         (get_local $2)
      )
      (else
         (get_local $2)
      )
    )
  )
)
