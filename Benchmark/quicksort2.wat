(module
   (table 0 anyfunc)
   (memory $0 1)
   (export "memory" (memory $0))
   (export "quicksort" (func $quicksort))
   (func $quicksort (param $0 i32) (param $1 i32)
       (local $2 i32)    //i
       (local $3 i32)    //j
       (local $4 i32)    //pivot
       (block $iflabel$0
          (br_if $iflabel$0 (i32.lt_s (get_local $0) (i32.const 10)))
       )
   )
)