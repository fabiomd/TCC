
(in-package #:wao)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (enable-curry-compose-reader-macros))

(defvar infinity
  #+sbcl
  SB-EXT:DOUBLE-FLOAT-POSITIVE-INFINITY
  #+ccl
  CCL::DOUBLE-FLOAT-POSITIVE-INFINITY
  #-(or sbcl ccl)
  (error "must specify a positive infinity value"))

(defun config (wasm)
  (setf *fitness-shell-path* "benchmark/fitness.sh")
	(let ((temp (webassembly-fitness *fitness-shell-path* wasm)))
    (let ((genome (get-wat-file-s-expression (concatenate 'string *original-file-path*))))
      (progress-notification "reading original")
      (let ((genome-dependecy-graph (generate-dependecy-graph genome)))
        (setf *original* (make-instance 'webassembly-software
                    	      :fitness (car temp)
                    	      :testtable (cadr temp)
                    	      :genome genome-dependecy-graph))
      )
      (done-notification)
      (progress-notification "populating")
    	(setf *max-population-size* (expt 2 8)
            ; *evals* (expt 2 18)
            ; *period* (ceiling (/ *evals* (expt 2 10)))  
    		    *fitness-predicate* #'<
            ; *tournament-size* 2
            ; *cross-chance* 2/3
            ; *tournament-eviction-size* 2
            ; *actions* (list #'add #'rm #'swap)
    		    *population* (loop :for n :below *max-population-size* :collect (copy *original*)))
      (done-notification)
    )
  )
)

(setf *original-file-path* "benchmark/testsuite/add.wat")

(defun run (wasm)
  (format t "~%")
  (config wasm))

(defun worst ()
  (cond ((equal #'< *fitness-predicate*) 999999)
        ((equal #'> *fitness-predicate*) 0)))


(defun test (webassembly-software-A)
    (notification "fitness")
    (let ((test-table (slot-value webassembly-software-A 'testtable)))
      (let ((fitness 0))
          (loop for x in test-table do
            (let ((temp (split-sequence:SPLIT-SEQUENCE #\space x :remove-empty-subseqs t)))
              (if (string-equal (car temp) "error")
                (progn
                  (if (string-equal (car temp) "true")
                      (progn 
                      (error-notification "has failed")
                      (block nil (return (list (worst) test-table))))))
                (progn 
                  (setf fitness (+ fitness (parse-integer(caddr temp))))))
              )
            ) fitness))
    ; (testtable-fitness (slot-value webassembly-software-A 'testtable))
)

(run "add.wasm")

(evolve #'test :max-evals 100) 

; (print (slot-value *original* 'genome))
; (let ((module (generate-dependecy-graph (slot-value *original* 'genome))))
;   (print module)
;   (let ((tempCODE (slot-value module 'body)))

;     ; (print (retrieve-code module))


;     ; (print tempCODE)
;     (let ((node (car (get-nodes-with-type tempCODE 'func-node))))
;       (print (webassembly-mutate node))
;     )

;     (print (retrieve-code module))
;     ; (print (eql (nth 3 tempCODE) (nth 4 tempCODE)))
;     ; (print (eql (nth 1 tempCODE) (nth 1 tempCODE)))
;     ; (print (eql (make-instance 'node) (make-instance 'node)))
;     ; (print (eql (type-of (make-instance 'node)) (type-of (make-instance 'node))))
;   )
; )
; (print-graph (generate-dependecy-graph (slot-value *original* 'genome)))

; (notification-with-step "evolving")
; (evolve #'test :max-evals *evals*
;                :period *period*
;                :target *original*)

; (evolve #'test :max-evals *evals*
;                       :period *period*
;                       :period-fn (lambda () (mapc #'funcall *checkpoint-funcs*)))

; (defmacro evolve
;     (test &key max-evals max-time target period period-fn every-fn filter))