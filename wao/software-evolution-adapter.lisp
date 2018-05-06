(in-package #:wao)

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
      :genome genome)))

(defmethod crossover (webassembly-software-A webassembly-software-B)
	; (notification (format t "crossover ~a ~a" webassembly-software-A webassembly-software-B))
	(notification "crossover")
	(let ((nodeA (draw-node (slot-value webassembly-software-A 'genome))))
		(let ((nodeB (draw-node (slot-value webassembly-software-B 'genome))))
			; (print nodeA)
			; (print nodeB)
			(let ((nodeTemp (cons
			    (if (listp (car nodeB))
			    	(car nodeB) 
			    	(list (car nodeB))
			    ) 
				; (car nodeB) 
				(cdr nodeA))))
				; (print nodeTemp)
				(with-slots (fitness testtable genome) webassembly-software-A
					; (print "antes")
					; (print genome)
					(let ((temp-webassembly-software (copy webassembly-software-A)))
						(setf (slot-value temp-webassembly-software 'genome)
							(replacenode (slot-value temp-webassembly-software 'genome) (car nodeTemp) (car (cdr nodeTemp)))
						)
					; (print "depois")
					; (print (slot-value temp-webassembly-software 'genome))
					temp-webassembly-software
					)
				)
			)
		)
	)
)

(defmethod mutate (webassembly-software-A)
	; (notification (format t "mutate ~a" webassembly-software-A))
	(notification "mutate")
	webassembly-software-A
  )

; (defmethod testtable-fitness (test-table)
;       (let ((fitness 0))
;           (loop for x in test-table do
;             (let ((temp (split-sequence:SPLIT-SEQUENCE #\space x :remove-empty-subseqs t)))
;               (if (string-equal (car temp) "error")
;                 (progn
;                   (if (string-equal (car temp) "true")
;                       (progn 
;                       (error-notification "has failed")
;                       (block nil (return (list (worst) test-table))))))
;                 (progn 
;                   (setf fitness (+ fitness (parse-integer(caddr temp))))))
;               )
;             ) fitness)
; )

; FITNESS UTIlS

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

; EXTRA METHODS

; PRINT THE OBJECTS OF THE SOFTWARE
(defmethod print-software ((webassembly webassembly-software))
    (with-slots (fitness testtable genome) webassembly
	      (print fitness)
	      (print testtable)
	      (print genome)))


; GENERATE THE DEPENDECY GRAPH
(defun generate-dependecy-graph (wat-code-graph)
	; CREATE THE DEPENDECY TREE
	(let ((root (make-instance 'root-dependecy-node)))
		; CREATE A DEPENDECY BETWEEN THEN
		(loop for sub-code in wat-code-graph do
			(print sub-code)
		)
		; (add-dependency root module)
	)
)

; GENERATE THE CODE GRAPH
(defun generate-code-graph (wat-code)
	(if (string= (car wat-code) "MODULE")
		; CREATE A MODULE NODE
		(let ((module (expand-module)))
			; CREATE THE CODE GRAPH
			(let ((wat-code-graph (list module)))
				; SCAN THE CODE
				(loop for sub-code in (cdr wat-code) do
					(let ((temp (expand sub-code)))
						(setf wat-code-graph (append wat-code-graph (list temp)))
					)
				)
				; RETURN THE CODE_GRAPH
				wat-code-graph
			)
		)
		(error-notification "require module")
	)
)

; RETRIEVE THE CODE AS STRING
(defun write-code (wat-code)
	(retrieve-code wat-code)
)