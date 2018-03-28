(in-package #:wao)

; WEBASSEMBLY SOFTWARE OBJECT
(defclass webassembly-software (software)
  ((fitness :initarg :fitness :accessor fitness :initform nil)
   (testtable :initarg :testtable :accessor testtable :initform nil)
   (genome :initarg :genome :accessor genome :initform nil)))

 ; COPY METHOD RECEIVES A SOFTWARE AND CREATE A COPY OF IT
(defmethod copy ((webassembly webassembly-software))
  (with-slots (fitness testtable genome) webassembly
    (make-instance (type-of webassembly)
      :fitness fitness
      :testtable testtable
      :genome genome)))

(defmethod crossover (webassembly-software-A webassembly-software-B)
	(notification (format t "crossover ~a ~a" webassembly-software-A webassembly-software-B))
	(let ((nodeA (getnode (slot-value webassembly-software-A 'genome))))
		(let ((nodeB (getnode (slot-value webassembly-software-B 'genome))))
			(replacenode-atposition (slot-value webassembly-software-A 'genome) nodeB)
		)
	)
	; webassembly-software-A
)

(defmethod mutate (webassembly-software-A)
	(notification (format t "mutate ~a" webassembly-software-A))
	webassembly-software-A
  )

(defmethod fitness (webassembly-software-A)
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
)

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