;;;; wao.asd

(asdf:defsystem #:wao
  :description "WebAssembly Optimization Algorithm to optimize low level language."
  :author "Fábio Moreira Duarte <fabio-mduarte2@hotmail.com>"
  :license "Specify license here"
  :serial t
  :depends-on (curry-compose-reader-macros
               split-sequence
               software-evolution-library
               trivial-timeout)
  :components ((:file "package")
               (:file "globals")
               (:file "utils")
               (:file "webassembly-symbol")
               (:file "webassembly-symbols-table"       :depends-on ("webassembly-symbol"))
               (:file "adapt"                           :depends-on ("utils" 
                                                                     "webassembly-symbols-table"))
               (:file "mutate"                          :depends-on ("utils"
                                                                     "adapt" 
                                                                     "webassembly-symbols-table"))
               (:file "crossover"                       :depends-on ("utils"
                                                                     "adapt"))
               (:file "collector"                       :depends-on ("utils"))
               (:file "nodes/generic"                   :depends-on ("utils"
                                                                     "adapt"))
               (:file "nodes/module"                    :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/scope"                     :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/table"                     :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/memory"                    :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/export"                    :depends-on ("utils" 
                                                                     "nodes/generic" 
                                                                     "nodes/scope"))
               (:file "nodes/signature"                 :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/param"                     :depends-on ("utils" 
                                                                     "nodes/signature"))
               (:file "nodes/result"                    :depends-on ("utils" 
                                                                     "nodes/signature"))
               (:file "nodes/body"                      :depends-on ("utils" 
                                                                     "nodes/signature"))
               (:file "nodes/block"                     :depends-on ("utils" 
                                                                     "nodes/generic"
                                                                     "nodes/body"))
               (:file "nodes/operator"                  :depends-on ("utils" 
                                                                     "nodes/signature" 
                                                                     "nodes/body"))
               (:file "nodes/then"                      :depends-on ("utils" 
                                                                     "nodes/block" 
                                                                     "nodes/body"))
               (:file "nodes/else"                      :depends-on ("utils" 
                                                                     "nodes/block" 
                                                                     "nodes/body"))
               (:file "nodes/if"                        :depends-on ("utils" 
                                                                     "nodes/block" 
                                                                     "nodes/body"
                                                                     "nodes/then"
                                                                     "nodes/else"
                                                                     "nodes/result"))
               (:file "nodes/conversor"                 :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/convert"                   :depends-on ("utils" 
                                                                     "nodes/conversor"))
               (:file "nodes/getlocal"                  :depends-on ("utils" 
                                                                     "nodes/signature"))
               (:file "nodes/setlocal"                  :depends-on ("utils" 
                                                                     "nodes/signature"))
               (:file "nodes/local"                     :depends-on ("utils" 
                                                                     "nodes/signature"))
               (:file "nodes/multiple"                  :depends-on ("utils" 
                                                                     "nodes/signature"))
               (:file "nodes/func"                      :depends-on ("utils" 
                                                                     "nodes/generic" 
                                                                     "nodes/signature" 
                                                                     "nodes/body"
                                                                     "nodes/multiple"))
               (:file "nodes/call"                      :depends-on ("utils" 
                                                                     "nodes/func" 
                                                                     "nodes/body"
                                                                     "adapt"
                                                                     "webassembly-symbols-table"))
               (:file "nodes/break"                     :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/breakIf"                   :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "nodes/loop"                      :depends-on ("utils" 
                                                                     "nodes/generic"
                                                                     "nodes/break"
                                                                     "nodes/breakIf"))
               (:file "expand"                          :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "retrieve"                        :depends-on ("utils" 
                                                                     "nodes/generic"))
               (:file "software-evolution-adapter"      :depends-on ("package" 
                                                                     "expand" 
                                                                     "retrieve"
                                                                     "mutate"
                                                                     "crossover"))
      			(:file "wao-core"                        :depends-on ("package"
                                                                     "globals"
                                                                     "utils"
                                                                     "software-evolution-adapter"))
               (:file "wao"                             :depends-on ("package" 
                                                                     "wao-core"))))