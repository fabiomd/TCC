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

; ****************************************************************************************************

(defun copy-convert (node)
	(with-slots (typeopin operator typeopout parameters) node
		(let ((temp-parameters '()))
			(loop for parameter in parameters do
				(setf temp-parameters (append temp-parameters (copy-body (list parameter))))
			)
			(let ((convert-node (make-instance 'convert-node
				:typeopin typeopin
				:operator operator
				:typeopout typeopout
				:parameters temp-parameters
				)))
				convert-node
			)
		)
	)
)

; ****************************************************************************************************

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

(defun check-convert-in-out (type-in type-out)
	(cond ((and (find (string-downcase type-in) *i-value-types* :test #'equal)
			(find (string-downcase type-out) *f-value-types* :test #'equal))
		  'T)
	      ((and (find (string-downcase type-in) *f-value-types* :test #'equal)
			(find (string-downcase type-out) *i-value-types* :test #'equal))
		  'T)
		  ('T nil)
	)
)

; ****************************************************************************************************

(defun generate-convert (webassembly-symbol-table node)
	(let ((choosen (choose (get-expected-outputs webassembly-symbol-table))))
		(let ((type-out (get-type-from-symbol (car choosen)))
			  (type-in  (get-node-return-type node webassembly-symbol-table))
			  (choosen-convert-operator (choose *convert-operators*)))
			(if (check-convert-in-out type-in type-out)
				(let ((convert-node (make-instance 'convert-node
										:typeopin (format-typeop type-in)
										:typeopout (format-typeop type-out)
										:operator (car choosen-convert-operator)
										:parameters (list node)
									)))
					convert-node
				)
				node
			)
		)
	)
)

; ****************************************************************************************************

(defun get-convert-return-type (node)
	(slot-value node 'typeopout)
)

(defun get-convert-parameters (node)
	(slot-value node 'parameters)
)