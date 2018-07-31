(in-package #:wao)

; ****************************************************************************************************
; SOFTWARE EVOLUTION METHODS
; ****************************************************************************************************

; WEBASSEMBLY SOFTWARE OBJECT
(defclass webassembly-software (software)
  ((fitness   :initarg :fitness   :accessor fitness   :initform nil)
   (testtable :initarg :testtable :accessor testtable :initform nil)
   (genome    :initarg :genome    :accessor genome    :initform nil)))

 ; COPY METHOD RECEIVES A SOFTWARE AND CREATE A COPY OF IT
(defmethod copy ((webassembly webassembly-software))
  (with-slots (fitness testtable genome) webassembly
    (make-instance (type-of webassembly)
      :fitness fitness
      :testtable testtable
      :genome (copy-module genome))))

(defmethod crossover (webassembly-software-A webassembly-software-B)
	(print "CROSSOVER")
	(let ((code-copy (copy webassembly-software-A)))
		(let ((module-A (slot-value code-copy 'genome))
			  (module-B (slot-value webassembly-software-B 'genome)))
			(let ((tempCODE-A (slot-value module-A 'body))
				  (tempCODE-B (slot-value module-B 'body)))
			    (let ((choosen-A (choose (get-nodes-with-type tempCODE-A 'func-node)))
			    	  (node-B (get-nodes-with-type tempCODE-B 'func-node)))
			    	(if (webassembly-crossover (car choosen-A) (nth (cdr choosen-A) node-B))
			    		(progn
			    			(print (retrieve-code module-A))
							code-copy
						)
						(t (error-notification "crossover has failed"))
					)
			    )
			)
		)
	)
)

(defmethod mutate (webassembly-software-A)
	(print "MUTATE")
	(let ((code-copy (copy webassembly-software-A)))
		(let ((module (slot-value code-copy 'genome)))
			(let ((tempCODE (slot-value module 'body)))
			    (let ((node (car (choose (get-nodes-with-type tempCODE 'func-node)))))
			    	(if (webassembly-mutate node)
			    		(progn
			    			(print (retrieve-code module))
							code-copy
						)
						(t (error-notification "mutation has failed"))
					)
			    )
			)
		)
	)
)

; ****************************************************************************************************
; SHELL SCRIPTS
; ****************************************************************************************************

; CALL THE SHELL SCRIPT AND RECEIVES IT OUTPUT
(defun webassembly-testsuite (test-script webassembly-wat-path)
	(let ((fitness-output-stream (make-string-output-stream)))
	    (uiop:run-program  (concatenate 'string "sh" " " test-script " " webassembly-wat-path) 
								:output fitness-output-stream
								:error :output 
								:error-output 
							  	:lines :ignore-error-status t)
	    (let ((result (get-output-stream-string fitness-output-stream)))
		    (block nil (return result))))
)

; CALLS THE FUNCTION TO GENERATE THE SUIT-TABLE AND CALCULATES ITS FITNESS
(defun webassembly-fitness (test-script webassembly-wat-path)
	(let ((result (webassembly-testsuite test-script webassembly-wat-path)))
		(let ((test-table (split-sequence:SPLIT-SEQUENCE #\Newline result :remove-empty-subseqs t)))
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
		(block nil (return (list fitness test-table)))))))

; ****************************************************************************************************
; PRINT
; ****************************************************************************************************

; PRINT THE OBJECTS OF THE SOFTWARE
(defmethod print-software ((webassembly webassembly-software))
    (with-slots (fitness testtable genome) webassembly
	      (print fitness)
	      (print testtable)
	      (print genome)))


; ****************************************************************************************************
; GRAPH
; ****************************************************************************************************

; GENERATE THE CODE GRAPH
(defun generate-dependecy-graph (wat-code)
	(if (string= (car wat-code) "MODULE")
		; CREATE A MODULE NODE
		(let ((module (expand-module)))
			; CREATE THE CODE GRAPH
			(let ((wat-code-graph '()))
				; SCAN THE CODE
				(loop for sub-code in (cdr wat-code) do
					(let ((temp (expand sub-code)))
						(setf wat-code-graph (append wat-code-graph (list temp)))
					)
				)
				(setf (slot-value module 'body) wat-code-graph)
				; RETURN THE CODE_GRAPH
				module
			)
		)
		(error-notification "require module")
	)
)

; ****************************************************************************************************
; MUTATE HELPER
; ****************************************************************************************************
