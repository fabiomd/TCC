;;;; wao.asd

(asdf:defsystem #:wao
  :description "WAO WebAssembly Optimization is a tool to optimize webassembly .wat code"
  :author "Fábio Moreira Duarte <fabio-mduarte2@hotmail.com>"
  :license "Specify license here"
  :serial t
  :components ((:file "package")
               (:file "wao")))

