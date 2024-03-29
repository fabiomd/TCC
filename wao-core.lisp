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

(defun config ()
  ; (setf *gensym-counter* 0)
  (setf *random-state* (get-key "benchmark/randomKey5.txt")
        *gensym-counter* 0
		sb-impl::*default-external-format* :UTF-8)
  ; (setf *random-state* (make-random-state t))
  (progress-notification "creating temp content")
  (ensure-directories-exist *watcode-path*)
  (ensure-directories-exist *wasmcode-path*)
  (done-notification)
  (setf *fitness-shell-path*      "./ShellScripts/test.sh"
        *wat-to-wasm-shell-path*  "./ShellScripts/wat2wasm.sh"
        *fitness-js-path*         "./TCC/benchmark/fitness/fitnessA.js")
  (let ((compiled-original (compile-original-wat-to-wasm))
         (temp (webassembly-fitness *fitness-shell-path* *compiled-original-file-path*)))
    (let ((genome (get-wat-file-s-expression (concatenate 'string *original-file-path*))))
      (progress-notification "reading original")
      (let ((genome-dependecy-graph (generate-dependecy-graph genome)))
          (setf *original* (make-instance 'webassembly-software
                    	      :fitness (car temp)
                    	      :testtable (cadr temp)
                    	      :genome genome-dependecy-graph))
       )
      (done-notification)
      (progress-notification "processing functions")
      (let ((module (slot-value *original* 'genome)))
        (let ((tempCODE (slot-value module 'body)))
           (populate-availables-functions (get-nodes-with-type tempCODE 'func-node) nil)
        )
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
      (done-notification)
      (progress-notification "collecting data from genome")
      (config-original-body-sizes)
      (done-notification)
    )
  )
)

(defun config-original-body-sizes ()
  (setf *original-body-nodes* (code-size *original*))
)

(setf *original-file-path* "benchmark/experiments/expA.wat")
(setf *compiled-original-file-path* "./TCC/benchmark/experiments/original.wasm")

(config)

(defun evolve-code ()
  (print "evolving ...")
  (evolve #'avaliate-code :max-evals *max-avaliations*) 
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
      (retrieve-code genome)
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
      (retrieve-code genome)
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