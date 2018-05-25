(in-package #:wao)

(defclass convert-node (conversor-node)
	())

; ****************************************************************************************************

(defun expand-convert (wat-code)
	(let ((temp (split-sequence #\. (write-to-string (car wat-code)))))
		(let ((temp2 (split-sequence #\/ (cadr temp))))
			(let ((convert-node (make-instance 'convert-node
				:typeopin  (car temp)
				:operator  (car temp2)
				:typeopout (cadr temp2)
				:parameters (expand-body (cdr wat-code)))))
				convert-node
			)
		)
	)
)

; ****************************************************************************************************

(defun retrieve-convert (node)
	(let ((code ""))
		(with-slots (typeopin operator typeopout parameters) node
			(let ((op (concatenate 'string typeopin "\." operator "\/" typeopout)))
				(setf code (concatenate 'string code "(" (string-downcase op) " "))
				(setf code (concatenate 'string code " " (retrieve-body parameters)))
				(setf code (concatenate 'string code ")"))
				code
			)
		)
	)
)

(defun check-convert (wat-code)
	(let ((temp (split-sequence #\. wat-code)))
		(let ((temp2 (split-sequence #\/ (cadr temp))))
			(if (and (listp temp2) (> (length temp2) 1))
				(cond ((and (find (string-downcase (car temp2)) *convert-operators* :test #'equal)
					        (or (find (string-downcase (car temp))   *f-value-types* :test #'equal)
					        	(find (string-downcase (cadr temp2)) *i-value-types* :test #'equal)
					        )) 
					  'T)
				      ((and (find (string-downcase (car temp2)) *convert-operators* :test #'equal)
					        (or (find (string-downcase (car temp))   *i-value-types* :test #'equal)
					        	(find (string-downcase (cadr temp2)) *f-value-types* :test #'equal)
					        ))
					   'T)
					  ('T nil)
				)
				nil
			)
		)
	)
)