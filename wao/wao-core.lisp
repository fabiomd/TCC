
(in-package #:wao)

; TODO study what it does
(eval-when (:compile-toplevel :load-toplevel :execute)
  (enable-curry-compose-reader-macros))

;;; Optimization Software Objects
(defclass webassembly-light (light wat)
  ((stats :initarg :stats :accessor stats :initform nil)))

(defun to-webassembly-light (webassembly)		
  (with-slots (fitness testsuite genome) webassembly
    (make-instance 'webassembly-light
      :fitness fitness
      :testsuite testsuite
      :genome genome)))

(defmethod copy ((webassembly webassembly-light))
  (with-slots (fitness testsuite genome) webassembly
    (make-instance (type-of webassembly)
      :fitness fitness
      :testsuite testsuite
      :genome genome)))

(defun config (wasm)
	(let ((temp (webassembly-fitness *fitness-shell-path* wasm)))
  	(setf *original* (make-instance (type-of 'webassembly-light)
    	      :fitness (car temp)
    	      :testsuite (cadr temp)
    	      :genome (get-wat-file-s-expression (concatenate 'string *original-file-path*)))))
  	(setf *max-population-size* (expt 2 8)
  		  *fitness-predicate* #'<
  		  *population* (loop :for n :below *max-population-size* :collect (copy *original*))))

(setf *original-file-path* "benchmark/testsuite/add.wat")

(defun run (wasm)
  (config wasm))

(run "add.wasm")