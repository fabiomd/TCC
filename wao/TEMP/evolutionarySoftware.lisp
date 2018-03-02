(ql:quickload :goa)
(load "src/goa-core.lisp")
(load "src/webassembly/classes.lisp")
; (load "src/webassembly/evolve.lisp")
(load "src/webassembly/utils.lisp")
(in-package :goa)

(require :asdf)
(asdf:load-system :uiop)

(setf *fitness-shell* "benchmarks/webassembly/fitness.sh")

;; FUNCTION COPY WASM
(defmethod copy ((wasm wasm-perf))
  (with-slots (fitness testsuite genome) wasm
  	(let ((perf (make-instance (type-of wasm))))
  		(setf (wasm-perf-fitness perf) fitness)
  		(setf (wasm-perf-genome perf) genome)
  		(setf (wasm-perf-testsuite perf) testsuite)
  		perf)))

;; CALL THE METODO TO GET THE FITNESS FOR EACH TEST-SUITE
(defun webassembly-testsuite (test-script wasm)
	(let ((fitness-output-stream (make-string-output-stream)))
	    (uiop:run-program  (concatenate 'string "sh" " " test-script " " wasm) 
								:output fitness-output-stream
								:error :output 
								:error-output 
							  	:lines :ignore-error-status t)
	    (let ((result (get-output-stream-string fitness-output-stream)))
		    (block nil (return result))))
)

;; GET THE TEST-SUITES AND CALCULATE THE FINAL FITNESS
;; :remove-empty-subseqs t é um parametro do split-sequence q remove strings vazias
(defun webassembly-fitness (test-script wasm)
	(let ((result (webassembly-testsuite test-script wasm)))
		(let ((test-table (split-sequence:SPLIT-SEQUENCE #\Newline result :remove-empty-subseqs t)))
		(let ((fitness 0))
			(loop for x in test-table do
				(let ((temp (split-sequence:SPLIT-SEQUENCE #\space x :remove-empty-subseqs t)))
					(if (string-equal (car temp) "error")
						(progn
						  (if (string-equal (car temp) "true")
						      (progn 
								  (print "has failed")
								  (block nil (return (list (worst) test-table))))))
						(progn 
						  (setf fitness (+ fitness (parse-integer(caddr temp))))))
					)
				)
		(block nil (return (list fitness test-table))))))
)

; (defun fitness (wasm)
; 	(wasm-perf-fitness wasm)
; 	)
	; (webassembly-fitness *fitness-shell* wasm))

;; SET ORIGIN
;; MODIFICAR CRIAR ARQUIVO A SER OTIMIZADO E UTILIZA-LO INVEZ DO ADD.WASM
(defun configGOA (wasm wat)
	(let ((perf (make-instance 'wasm-perf)))
	(let ((temp (webassembly-fitness *fitness-shell-path* wasm)))
		(setf (wasm-perf-fitness perf) (car temp)
		      (wasm-perf-testsuite perf) (cadr temp)
		; (setf (wasm-perf-genome perf) (concatenate-list (get-wat-file "benchmarks/webassembly/testsuite/add.wat"))))
	          (wasm-perf-genome perf) (get-wat-file-s-expression (concatenate 'string "benchmarks/webassembly/testsuite/" wat))))
	(setf *orig* perf))
	; (print (wasm-perf-genome *orig*))
	; (print (nth 2 (nth 3 (get-genome-at-position 5 *orig*))))
	; (print (wasm-perf-fitness *orig*))
	; (print (wasm-perf-testsuite *orig*))
	; (print (wasm-perf-genome *orig*))
	; (print (nth (get-nth '(memory $0 1) (wasm-perf-genome *orig*)) (wasm-perf-genome *orig*)))
	; (print (get-genome-at-position 2 *orig*))
	; (print (copy *orig*))
	(setf *max-population-size* (expt 2 8)
		  ; *evals* (expt 2 18)                    ; max runtime in evals
		  ; *threads* 12                           ; number of threads
		  *fitness-predicate* #'<
		  *population* (loop :for n :below *max-population-size* :collect (copy *orig*)))
	; (print (cadr (wasm-perf-genome *orig*)))
	; (print (split-sequence:SPLIT-SEQUENCE #\( (wasm-perf-genome *orig*) :remove-empty-subseqs t))
)



;; DEFINE FUNCTION RUN
(defun run (wasm wat)
	(note 4 "running ~S~%" wasm)
	(configGOA wasm wat)
)

(run "add.wasm" "add.wat")

(defun test (wasm-perf-a)
	(print wasm-perf-a))

; (defun testsoftware (webassembly-wat-software)
; 	(print webassembly-wat-software))

(defun testsoftware ()
	(let ((perf (make-instance (type-of 'webassembly-wat-software))))
  		(setf (fitness perf) 'fitness)
  		(setf (genome perf) 'genome)
  		(setf (testsuite perf) 'testsuite)
  		(print perf))
)

(testsoftware)
; (defun test (wasm wat)
;   ;; if the variant has not yet been run, then run and save the
;   ;; metrics to `stats'
;   (unless (stats wasm) (setf (stats wasm) (run wasm wat)))
;   ;; fitness function combining HW counters
;   (assert nil nil "Implement a fitness function HERE."))
; ;; TEST THE WASM
; ; (defun test (wasm)
; ;   (unless (stats wasm) (setf (stats wasm) (run wasm)))
; ;   (run wasm))

; ;; SET GLOBAL VARS
; ; (setf
; ;  (fitness *orig*) (test *orig*)
; ;  *max-population-size* (expt 2 8)
; ;  *fitness-predicate* #'<
; ;  *population* (loop :for n :below *max-population-size* :collect (copy *orig*)))

; (print "Evolving")
; (evolve #'test)
