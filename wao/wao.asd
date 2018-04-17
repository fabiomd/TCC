;;;; wao.asd

(asdf:defsystem #:wao
  :description "WebAssembly Optimization Algorithm to optimize high level language."
  :author "Fábio Moreira Duarte <fabio-mduarte2@hotmail.com>"
  :license "Specify license here"
  :serial t
  :depends-on (curry-compose-reader-macros
;;;;               cl-ppcre
               split-sequence
               software-evolution
               software-evolution-utility)
  :components ((:file "package")
               (:file "globals")
               (:file "utils")
               (:file "software-evolution-adapter" :depends-on ("package"))
      			   (:file "wao-core" :depends-on ("package" "globals" "utils" "software-evolution-adapter"))
               (:file "wao"      :depends-on ("package" "wao-core"))))