
(in-package #:wao)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (enable-curry-compose-reader-macros))

(defun config (wasm)
  (setf *fitness-shell-path* "benchmark/fitness.sh")
	(let ((temp (webassembly-fitness *fitness-shell-path* wasm)))
    (let ((genome (get-wat-file-s-expression (concatenate 'string *original-file-path*))))
    (setf *original* (make-instance 'webassembly-software
                	      :fitness (car temp)
                	      :testsuite (cadr temp)
                	      :genome genome))))
  	(setf *max-population-size* (expt 2 8)
  		    *fitness-predicate* #'<
  		    *population* (loop :for n :below *max-population-size* :collect (copy *original*))))

(setf *original-file-path* "benchmark/testsuite/add.wat")

(defun run (wasm)
  (notification-with-step "configurating initial variables")
  (config wasm))

(defun test (webassembly-software)
  (print webassembly-software))

(run "add.wasm")

; (print "Evolving")
; (evolve #'test)