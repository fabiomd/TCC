
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
  (progress-notification "creating temp content")
  (ensure-directories-exist *watcode-path*)
  (ensure-directories-exist *wasmcode-path*)
  (done-notification)
  (setf *fitness-shell-path*      "ShellScripts/test.sh"
        *wat-to-wasm-shell-path*  "ShellScripts/wat2wasm.sh"
        *fitness-js-path*         "benchmark/fitness.js")
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
            *evals* (expt 2 18)
            ; *period* (ceiling (/ *evals* (expt 2 10)))  
    		    *fitness-predicate* #'>
            *tournament-size* 2
            *cross-chance* 2/3
            ; *tournament-eviction-size* 2
            ; *actions* (list #'add #'rm #'swap)
    		    *population* (loop :for n :below *max-population-size* :collect (copy *original*)))
      (config-original-body-sizes)
      (done-notification)
    )
  )
)

(defun config-original-body-sizes ()
  (let ((original-module (slot-value *original* 'genome)))
      (let ((tempCODE (slot-value original-module 'body)))
          (setf *count-body-nodes* '())
          (loop for func in (get-nodes-with-type tempCODE 'func-node) do
              (let ((body (slot-value func 'body)))
                  (setf *count-body-nodes* (append *count-body-nodes* (list (count-body-nodes body))))
              )
          )
      )
  )
)

(setf *original-file-path* "benchmark/original.wat")

(defun run (wasm)
  (format t "~%")
  (config wasm))

(defun worst ()
  (cond ((equal #'< *fitness-predicate*) 999999)
        ((equal #'> *fitness-predicate*) 0)))


(defun test (webassembly-software-A)
    (print "TEST FITNESS")
    (let ((id (slot-value webassembly-software-A 'id))
          (module (slot-value webassembly-software-A 'genome)))
      (print "ID")
      (print id)
      (let ((content (retrieve-code module)))
        (let ((file (save-file *watcode-path* (write-to-string id) *wat-extension* content)))
          (print "FILE")
          (print file)
        )
      )
    )
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
            ) 
          (print fitness)
          fitness))
)

(run "add.wasm")

(defun evolve-code ()
  (evolve #'avaliate-code :max-evals 2000) 
)

(defun get-best ()
  (let ((best *original*))
    (loop for individual in *population* do
        (if (> (slot-value individual 'fitness) (slot-value best 'fitness))
            (setf best individual)
        ) 
    )
    (with-slots (id fitness testtable genome) best
      (print "BEST INDIVIDUAL")
      (print id)
      (print fitness)
      (print (retrieve-code genome))
    )
  )
)

(defun get-worth ()
  (let ((worth *original*))
    (loop for individual in *population* do
        (if (< (slot-value individual 'fitness) (slot-value worth 'fitness))
            (setf worth individual)
        ) 
    )
    (with-slots (id fitness testtable genome) worth
      (print "WORTH INDIVIDUAL")
      (print id)
      (print fitness)
      (print (retrieve-code genome))
    )
  )
)

; (notification-with-step "evolving")
; (evolve #'test :max-evals *evals*
;                :period *period*
;                :target *original*)

; (evolve #'test :max-evals *evals*
;                       :period *period*
;                       :period-fn (lambda () (mapc #'funcall *checkpoint-funcs*)))

; (defmacro evolve
;     (test &key max-evals max-time target period period-fn every-fn filter))