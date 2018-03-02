; (ql:quickload :goa)
; (load "src/goa-core.lisp")
; (in-package :goa)
(require :asdf)
(asdf:load-system :uiop)
; (:use :uiop)

(setf *orig* (from-file (make-instance 'asm-perf) "benchmarks/webassembly/original.wat"))


; define the run function
; (defun test (wasm)
;   ;; if the variant has not yet been run, then run and save the
;   ;; metrics to `stats'
;   (unless (stats wasm) (setf (stats wasm) (run wasm)))
;   ;; fitness function combining HW counters
;   (assert nil nil "Implement a fitness function HERE."))

(defun webassembly-fitness2 (wasm)
	; (defun c:runFitnessFile ()

    ; CHAMA O SCRIPT QUE CALCULA O FITNESS, PASSA O WASM COMO PARAMETRO

	; (uiop:run-program  (concatenate 'string "sh benchmarks/webassembly/fitness.sh" " " wasm) 
	; 	:output *standard-output* 
	; 	:error :output 
	; 	:error-output 
	; 	:lines :ignore-error-status t)


	; (get-output-stream-string result-stream)
	; (print "testing")

	; (setq a-stream (make-string-output-stream)
 ;        a-string "abcdefghijklm")
	; (write-string a-string a-stream)
	; (get-output-stream-string a-stream)
	; (get-output-stream-string a-stream)

	; (setq *teste* (let ((result (make-string-output-stream)))
 ;    (uiop:run-program  (concatenate 'string "sh benchmarks/webassembly/fitness.sh" " " wasm) 
	; 	:output result 
	; 	:error :output 
	; 	:error-output 
	;   	:lines :ignore-error-status t)
 ;    (get-output-stream-string result)))
 ;    (print "teste result")
 ;    *teste*

    (let ((fitness-output-stream (make-string-output-stream)))
    (uiop:run-program  (concatenate 'string "sh benchmarks/webassembly/fitness.sh" " " wasm) 
							:output fitness-output-stream 
							:error :output 
							:error-output 
						  	:lines :ignore-error-status t)
    (let ((result (get-output-stream-string fitness-output-stream)))
	    (print "my result")
	    (print result)
	    (block nil (return result))))



	; (uiop:run-program "sh benchmarks/webassembly/fitness.sh" :output *standard-output* :error :output :error-output :lines :ignore-error-status t)
	; (sb-ext:run-program "benchmarks/webassembly/fitness.sh" nil :wait t :input :stream :output :stream)
	; (sb-ext:run-program "benchmarks/webassembly/fitness.sh" '("rh@..." "'DISPLAY=:0 scrot capture.png'")
	
	; (shell "benchmarks/webassembly/fitness.sh" + " " + wasm)
	; (run-program "benchmarks/webassembly/fitness.sh" + " " + wasm + " '() :output *standard-output*")
    ;   (startapp "benchmarks/webassembly/fitness.sh" + " " + wasm)
    ;   (princ)
    ; )
)

(defun get-wat-file (wat-filename)
  (with-open-file (stream wat-filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun concatenate-list( list )
  (format nil "~{~a~}" list))

(defun webassembly-testsuite (test-script wasm)
	(let ((fitness-output-stream (make-string-output-stream)))
	    (uiop:run-program  (concatenate 'string "sh" " " test-script " " wasm) 
								:output fitness-output-stream 
								:error :output 
								:error-output 
							  	:lines :ignore-error-status t)
	    (let ((result (get-output-stream-string fitness-output-stream)))
		    (print "my result")
		    (print result)
		    (block nil (return result))))
)

(defun run (wasm)
  (let ((test-script (assert nil nil "benchmarks/webassembly/fitness.js")))
  	(webassembly-fitness test-script wasm)))

(run "add.wasm")

(defun webassembly-fitness (test-script wasm)
	(let ((result (webassembly-testsuite test-script wasm)))
		(print result))
)
(setf
 ;; set the fitness of the original individual
 (webassembly-fitness *orig*) (test *orig*)
 ;; set the maximum population size
 *max-population-size* (expt 2 8)
 ;; specify that lower fitness values are better
 *fitness-predicate* #'<
 ;; fill the population with copies of the original
 *population* (loop :for n :below *max-population-size* :collect (copy *orig*)))

;; (6)
(evolve #'test)
