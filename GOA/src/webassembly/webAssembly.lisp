(ql:quickload :goa)
(load "src/goa-core.lisp")
(in-package :goa)

(require :asdf)
(asdf:load-system :uiop)

; DEFINITION OF CLASSES

; (defclass box ()
;    ((length :accessor box-length)
;       (breadth :accessor box-breadth)
;       (height :accessor box-height)
;       (volume :reader volume)
;    )
; )

; ; method calculating volume   

; (defmethod volume ((object box))
;    (* (box-length object) (box-breadth object)(box-height object))
; )

;  ;setting the values 

; (setf item (make-instance 'box))
; (setf (box-length item) 10)
; (setf (box-breadth item) 10)
; (setf (box-height item) 5)

; ; displaying values

; (format t "Length of the Box is ~d~%" (box-length item))
; (format t "Breadth of the Box is ~d~%" (box-breadth item))
; (format t "Height of the Box is ~d~%" (box-height item))
; (format t "Volume of the Box is ~d~%" (volume item))

(defvar *fitness-shell* "benchmarks/webassembly/fitness.sh")

; ;; CLASS TO SAVE PERFORMANCE
(defclass orig-wasm-perf ()
	((fitness :accessor orig-wasm-perf-fitness)
	 (testsuite :accessor orig-wasm-perf-testsuite)
	 (genome :accessor orig-wasm-perf-genome))
)

(defclass wasm-perf ()
	((fitness :accessor wasm-perf-fitness)
	 (testsuite :accessor wasm-perf-testsuite)
	 (genome :accessor wasm-perf-genome))
)

;; REDEFINITION OF FROM-FILE
(defun get-wat-file (wat-filename)
  (with-open-file (stream wat-filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

;; FUNCTION TO READ A WAT FILE
(defun get-wat-file (wat-filename)
  (with-open-file (stream wat-filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun get-wat-file-sexpression (wat-filename)
	(with-open-file (file wat-filename
                  :direction :input)
	  (read file))
)

;; FUNCTION COPY WASM
(defmethod copy ((wasm wasm-perf))
  (with-slots (wasm-perf-genome wasm-perf-fitness wasm-perf-testsuite) wasm
    (make-instance (type-of wasm)
      :fitness (wasm-perf-fitness wasm)
      :genome (copy-tree wasm-perf-genome)
      :testsuite (wasm-perf-testsuite wasm))))

;; FUNCTION TO READ LIST
(defun get-nth (element xlist)
	(let ((idx 0))
		(catch 'get-nth
			(dolist (x xlist)
				(when (equal element x) (throw 'get-nth idx))
				(setq idx (1+ idx)))
			nil)
		)
)

;; FUNCTION TO WALK ON GENOME
(defun get-genome-at-position (pos wasm-p)
	(nth pos (wasm-perf-genome wasm-p))
)

;; SINZE WAT FILE WILL BE RETURNED AS A LIST, THIS FUNCTION TURNS IT INTO A SINGLE STRING
(defun concatenate-list( list )
  (format nil "~{~a~}" list))

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
								  (return))))
						(progn 
						  (setf fitness (+ fitness (parse-integer(caddr temp))))))
					)
				)
		(block nil (return (list fitness test-table))))))
)
;; #\space

;; RUN THE OPTIMIZATION TO THE WASM FILE
; (defun run (wasm wat)
;   (let ((test-script (assert nil nil "benchmarks/webassembly/fitness.js")))
;   	(webassembly-fitness test-script wasm)))

;; SET ORIGIN
; (setf *orig* (from-file (make-instance 'wat-perf) "benchmarks/webassembly/original.wat"))

;; SET ORIGIN
;; MODIFICAR CRIAR ARQUIVO A SER OTIMIZADO E UTILIZA-LO INVEZ DO ADD.WASM
(defun configOrig (wasm wat)
	(let ((perf (make-instance 'wasm-perf)))
	(let ((temp (webassembly-fitness *fitness-shell* wasm)))
		(print temp)
		(setf (wasm-perf-fitness perf) (car temp))
		(setf (wasm-perf-testsuite perf) (cadr temp))
		; (setf (wasm-perf-genome perf) (concatenate-list (get-wat-file "benchmarks/webassembly/testsuite/add.wat"))))
	    (setf (wasm-perf-genome perf) (get-wat-file-sexpression (concatenate 'string "benchmarks/webassembly/testsuite/" wat))))
	(setf *orig* perf))
	(print (wasm-perf-fitness *orig*))
	(print (wasm-perf-testsuite *orig*))
	(print (wasm-perf-genome *orig*))
	(print (nth (get-nth '(memory $0 1) (wasm-perf-genome *orig*)) (wasm-perf-genome *orig*)))
	(print (get-genome-at-position 2 *orig*))
	(print (copy *orig*))
	; (print (cadr (wasm-perf-genome *orig*)))
	; (print (split-sequence:SPLIT-SEQUENCE #\( (wasm-perf-genome *orig*) :remove-empty-subseqs t))
)

;; DEFINE FUNCTION RUN
(defun run (wasm wat)
	(configOrig wasm wat)
)

(run "add.wasm" "add.wat")


;; TEST THE WASM
; (defun test (wasm)
;   (unless (stats wasm) (setf (stats wasm) (run wasm)))
;   (run wasm))

;; SET GLOBAL VARS
; (setf
;  (fitness *orig*) (test *orig*)
;  *max-population-size* (expt 2 8)
;  *fitness-predicate* #'<
;  *population* (loop :for n :below *max-population-size* :collect (copy *orig*)))

; (evolve #'test)
