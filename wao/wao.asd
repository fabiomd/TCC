;;;; wao.asd

(asdf:defsystem #:wao
  :description "WebAssembly Optimization Algorithm to optimize high level language."
  :author "Fábio Moreira Duarte <fabio-mduarte2@hotmail.com>"
  :license "Specify license here"
  :serial t
  :components ((:file "package")
               (:file "globals")
               (:file "utils")
			   (:file "wao-core" :depends-on ("package" "globals" "utils"))
               (:file "wao"      :depends-on ("package" "wao-core"))))