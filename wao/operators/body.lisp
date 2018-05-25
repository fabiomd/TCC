(in-package #:wao)

; ****************************************************************************************************

(defun expand-body (wat-code)
	(let ((body-node '()))
		(loop for body in wat-code do
			(cond ((check-operator (write-to-string (car body)))
				     (setf body-node (append body-node (list (expand-operator body)))))
				  ((string= "GET_LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-get-local body)))))
				  ((check-convert (write-to-string (car body)))
				  	 (setf body-node (append body-node (list (expand-convert body)))))
				  (t (error-notification "undefined body operator"))
		    )
		)
		body-node
	)
)

; ****************************************************************************************************

(defun retrieve-body (nodes)
	(let ((code ""))
		(loop for node in nodes do
			(cond ((eql (type-of node) 'operator-node)
			      	   (setf code (concatenate 'string code (retrieve-operator  node))))
			      ((eql (type-of node) 'get-local-node)
				       (setf code (concatenate 'string code (retrieve-get-local node))))
			      ((eql (type-of node) 'convert-node)
			      	   (setf code (concatenate 'string code (retrieve-convert node))))
				  (t (error-notification "undefined signature"))
		    )
		)
		code
	)
)
