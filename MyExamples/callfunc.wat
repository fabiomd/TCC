(module
  (table 0 anyfunc)
  (memory $0 1)
  (export "memory" (memory $0))
  (export "_Z3addii" (func $_Z3addii))
  (export "main" (func $main))
  (func $_Z3addii (param $0 i32) (param $1 i32) (result i32)
    (i32.add
      (get_local $1)
      (get_local $0)
    )
  )
  (func $main (result i32)
    (call $_Z3addii
      (i32.const 1)
      (i32.const 2)
    )
  )
)
