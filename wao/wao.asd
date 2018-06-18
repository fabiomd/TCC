;;;; wao.asd

(asdf:defsystem #:wao
  :description "WebAssembly Optimization Algorithm to optimize low level language."
  :author "Fábio Moreira Duarte <fabio-mduarte2@hotmail.com>"
  :license "Specify license here"
  :serial t
  :depends-on (curry-compose-reader-macros
               split-sequence
               software-evolution
               software-evolution-utility)
  :components ((:file "package")
               (:file "globals")
               (:file "utils")
               (:file "webassembly-symbol")
               (:file "webassembly-symbols-table"       :depends-on ("webassembly-symbol"))
               (:file "swap"                :depends-on ("utils" 
                                                         "webassembly-symbols-table"))
               (:file "mutate"              :depends-on ("utils" 
                                                         "webassembly-symbols-table"))
               (:file "operators/generic"   :depends-on ("utils"))
               (:file "operators/module"    :depends-on ("utils" 
                                                         "operators/generic"))
               (:file "operators/scope"     :depends-on ("utils" 
                                                         "operators/generic"))
               (:file "operators/table"     :depends-on ("utils" 
                                                         "operators/generic"))
               (:file "operators/memory"    :depends-on ("utils" 
                                                         "operators/generic"))
               (:file "operators/export"    :depends-on ("utils" 
                                                         "operators/generic" 
                                                         "operators/scope"))
               (:file "operators/signature" :depends-on ("utils" 
                                                         "operators/generic"))
               (:file "operators/param"     :depends-on ("utils" 
                                                         "operators/signature"))
               (:file "operators/result"    :depends-on ("utils" 
                                                         "operators/signature"))
               (:file "operators/body"      :depends-on ("utils" 
                                                         "operators/signature"))
               (:file "operators/operator"  :depends-on ("utils" 
                                                         "operators/signature" 
                                                         "operators/body"))
               (:file "operators/conversor" :depends-on ("utils" 
                                                         "operators/generic"))
               (:file "operators/convert"   :depends-on ("utils" 
                                                         "operators/conversor"))
               (:file "operators/getlocal"  :depends-on ("utils" 
                                                         "operators/signature"))
               (:file "operators/func"      :depends-on ("utils" 
                                                         "operators/generic" 
                                                         "operators/signature" 
                                                         "operators/body"))
               (:file "expand"   :depends-on ("utils" 
                                              "operators/generic"))
               (:file "retrieve" :depends-on ("utils" 
                                              "operators/generic"))
               (:file "software-evolution-adapter" :depends-on ("package" 
                                                                "expand" 
                                                                "retrieve"
                                                                "mutate"
                                                                "swap"))
      			   (:file "wao-core" :depends-on ("package"
                                              "globals"
                                              "utils"
                                              "software-evolution-adapter"))
               (:file "wao"      :depends-on ("package" 
                                              "wao-core"))))