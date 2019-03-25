(in-package #:wao)

; ****************************************************************************************************
; SOFTWARE EVOLUTION METHODS
; ****************************************************************************************************

; WEBASSEMBLY SOFTWARE OBJECT
(defclass webassembly-software (software)
  ((fitness   :initarg :fitness   :accessor fitness   :initform nil)
   (testtable :initarg :testtable :accessor testtable :initform nil)
   (genome    :initarg :genome    :accessor genome    :initform nil)
   (id        :initarg :id        :accessor id        :initform (generate-symbol))))


; ****************************************************************************************************

 ; COPY METHOD RECEIVES A SOFTWARE AND CREATE A COPY OF IT
(defmethod copy ((webassembly webassembly-software))
  (with-slots (fitness testtable genome) webassembly
    (make-instance (type-of webassembly)
      :fitness fitness
      :testtable testtable
      :genome (copy-module genome))))

; ****************************************************************************************************

; CROSSOVER METHOD RECEIVES TWO OBJECTS AND RETURN A NEW ONE
(defmethod crossover (webassembly-software-A webassembly-software-B)
	(print "CROSSOVER")
	(let ((code-copy (copy webassembly-software-A)))
		(let ((module-A (slot-value code-copy 'genome))
			  (module-B (slot-value webassembly-software-B 'genome)))
			(let ((tempCODE-A (slot-value module-A 'body))
				  (tempCODE-B (slot-value module-B 'body)))
			    (let ((choosen-A (choose (get-nodes-with-type tempCODE-A 'func-node)))
			    	  (node-B (get-nodes-with-type tempCODE-B 'func-node)))
			    	(let ((crossover (webassembly-crossover (car choosen-A) (nth (cdr choosen-A) node-B))))
			    		(progn
			    			(print (retrieve-code module-A))
							code-copy
						)
						; (t (error-notification "crossover has failed"))
					)
			    )
			)
		)
	)
)

; ****************************************************************************************************

; MUTATE METHOD RECEIVES ONE OBJECT AN RETURN A NEW ONE
(defmethod mutate (webassembly-software-A)
	(print "MUTATE")
	(let ((code-copy (copy webassembly-software-A)))
		(let ((module (slot-value code-copy 'genome)))
			(let ((tempCODE (slot-value module 'body)))
			    (let ((node (car (choose (get-nodes-with-type tempCODE 'func-node)))))
			    	(let ((mutation (webassembly-mutate node)))
			    		(progn
			    			(print (retrieve-code module))
							code-copy
						)
						; (t (error-notification "mutation has failed"))
					)
			    )
			)
		)
	)
)

; ****************************************************************************************************

(defun avaliate-code (webassembly-software)
	(print "FITNESS")
	(with-slots (id genome) webassembly-software
		(let ((content (retrieve-code genome))
			  (size (code-size webassembly-software)))
			; SAVE FILE
			(let ((file (save-file *watcode-path* (write-to-string id) *wat-extension* content)))
			; GET GENERATED CODE PATH
			  (let ((filepath (concatenate 'string *watcode-path* (write-to-string id) *wat-extension*))
			  	    (wasmfilepath (concatenate 'string *wasmcode-path* (write-to-string id) *wasm-extension*)))
			  ; COMPILE WAT CODE
				  (let ((compiled (compile-wat-to-wasm (write-to-string id))))
				; CALCULATE THE FITNESS
				      (if compiled
						  (let ((fitness (webassembly-fitness *fitness-shell-path* wasmfilepath)))
						  	  (let ((final-fitness (+ (car fitness) (fitness-size-bonus size))))
						  	  	(print final-fitness)
						  	  	(setf (slot-value webassembly-software 'fitness) final-fitness)
						  	  	final-fitness
						  	  )
					      )
					      worst
				      )
			      )
		      )
	      )
		)
	)
)

(defun fitness-size-bonus (code-size)
	(let ((counter 0.0))
		(loop for i from 0 to (- (length code-size) 1) do
			(setf counter (+ counter 
				(* (- (nth i *original-body-nodes*) (nth i code-size)) 0.001))
			)
		)
		counter
	)
)

(defun code-size (webassembly-software)
	(let ((code-module (slot-value webassembly-software 'genome)))
	    (let ((tempCODE (slot-value code-module 'body)))
	        (setf counter '())
	        (loop for func in (get-nodes-with-type tempCODE 'func-node) do
	            (let ((body (slot-value func 'body)))
	            	(setf counter (append counter (list (count-body-nodes body))))
	            )
	        )
	        counter
	    )
    )
)

; ****************************************************************************************************
; SHELL SCRIPTS
; ****************************************************************************************************

; CALL THE COMPILE SHELL SCRIPT AND RECEIVES IT OUTPUT
(defun compile-wat-to-wasm (webassembly-code-id)
	(let ((compiler-output-stream (make-string-output-stream))
		  (wat-path (concatenate 'string "." *watcode-path* webassembly-code-id *wat-extension*))
		  (wasm-path (concatenate 'string "." *wasmcode-path* webassembly-code-id *wasm-extension*)))
	    (uiop:run-program  (concatenate 'string "sh " *wat-to-wasm-shell-path* " " wat-path " " wasm-path) 
								:output compiler-output-stream
								:error :output 
								:error-output 
							  	:lines :ignore-error-status t)
	    (let ((result (get-output-stream-string compiler-output-stream)))
		    (block nil (return result))))
)

; CALL THE TEST SHELL SCRIPT AND RECEIVES IT OUTPUT
(defun webassembly-testsuite (test-script webassembly-wasm-path)
	(let ((fitness-output-stream (make-string-output-stream)))
	    (uiop:run-program  (concatenate 'string "sh ./" test-script " ./" *fitness-js-path* " " webassembly-wasm-path) 
								:output fitness-output-stream
								:error :output 
								:error-output 
							  	:lines :ignore-error-status t)
	    (let ((result (get-output-stream-string fitness-output-stream)))
		    (block nil (return result))))
)

; CALLS THE FUNCTION TO GENERATE THE SUIT-TABLE AND CALCULATES ITS FITNESS
(defun webassembly-fitness (test-script webassembly-wasm-path)
	(let ((result (webassembly-testsuite test-script webassembly-wasm-path)))
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
						  (setf fitness (+ fitness (parse-fitness(caddr temp))))))
					)
				)
		(block nil (return (list fitness test-table)))))))

; ****************************************************************************************************
; PRINT
; ****************************************************************************************************

; PRINT THE OBJECTS OF THE SOFTWARE
(defmethod print-software ((webassembly webassembly-software))
    (with-slots (id fitness testtable genome) webassembly
    	  (print id)
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
