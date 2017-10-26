(module
  (table 0 anyfunc)
  (memory $0 1)
  (export "memory" (memory $0))
  (export "quicksort" (func $quicksort))
  (func $quicksort (param $0 i32) (param $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (local $8 i32)
    (local $9 i32)
    (local $10 i32)
    (local $11 i32)
    (block $label$0
      (br_if $label$0
        (i32.lt_s
          (get_local $1)
          (i32.const 2)
        )
      )
      (loop $label$1
        (set_local $3
          (i32.add
            (get_local $0)
            (i32.const -4)
          )
        )
        (set_local $2
          (i32.load
            (i32.add
              (get_local $0)
              (i32.and
                (i32.shl
                  (get_local $1)
                  (i32.const 1)
                )
                (i32.const -4)
              )
            )
          )
        )
        (set_local $7
          (i32.const 0)
        )
        (set_local $11
          (get_local $1)
        )
        (loop $label$2
          (set_local $9
            (i32.add
              (get_local $7)
              (i32.const -1)
            )
          )
          (set_local $8
            (i32.add
              (get_local $3)
              (i32.shl
                (get_local $7)
                (i32.const 2)
              )
            )
          )
          (loop $label$3
            (set_local $9
              (i32.add
                (get_local $9)
                (i32.const 1)
              )
            )
            (br_if $label$3
              (i32.lt_s
                (tee_local $4
                  (i32.load
                    (tee_local $8
                      (i32.add
                        (get_local $8)
                        (i32.const 4)
                      )
                    )
                  )
                )
                (get_local $2)
              )
            )
          )
          (set_local $7
            (i32.add
              (get_local $9)
              (i32.const 1)
            )
          )
          (set_local $10
            (i32.add
              (get_local $3)
              (i32.shl
                (get_local $11)
                (i32.const 2)
              )
            )
          )
          (loop $label$4
            (set_local $11
              (i32.add
                (get_local $11)
                (i32.const -1)
              )
            )
            (set_local $5
              (i32.load
                (get_local $10)
              )
            )
            (set_local $10
              (tee_local $6
                (i32.add
                  (get_local $10)
                  (i32.const -4)
                )
              )
            )
            (br_if $label$4
              (i32.gt_s
                (get_local $5)
                (get_local $2)
              )
            )
          )
          (block $label$5
            (br_if $label$5
              (i32.ge_s
                (get_local $9)
                (get_local $11)
              )
            )
            (i32.store
              (get_local $8)
              (get_local $5)
            )
            (i32.store
              (i32.add
                (get_local $6)
                (i32.const 4)
              )
              (get_local $4)
            )
            (br $label$2)
          )
        )
        (call $quicksort
          (get_local $0)
          (get_local $9)
        )
        (set_local $0
          (get_local $8)
        )
        (br_if $label$1
          (i32.gt_s
            (tee_local $1
              (i32.sub
                (get_local $1)
                (get_local $9)
              )
            )
            (i32.const 1)
          )
        )
      )
    )
  )
)
