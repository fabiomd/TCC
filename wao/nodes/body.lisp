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
				  (t (error-notification "undefined body expand method"))
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
			      	   (setf code (concatenate 'string code " " (retrieve-operator  node))))
			      ((eql (type-of node) 'get-local-node)
				       (setf code (concatenate 'string code " " (retrieve-get-local node))))
			      ((eql (type-of node) 'convert-node)
			      	   (setf code (concatenate 'string code " " (retrieve-convert node))))
				  (t (error-notification "undefined body retrieve method"))
		    )
		)
		code
	)
)

; ****************************************************************************************************

(defun copy-body (nodes)
	(let ((code '()))
		(loop for node in nodes do
			(cond ((eql (type-of node) 'operator-node)
			      	   (setf code (append code (list (copy-operator node)))))
			      ((eql (type-of node) 'get-local-node)
			      	   (setf code (append code (list (copy-get-local node)))))
			      ((eql (type-of node) 'convert-node)
			      	   (setf code (append code (list (copy-convert node)))))
				  (t (error-notification "undefined body copy method"))
		    )
		)
		code
	)
)

; ****************************************************************************************************

(defvar generate-operator-chance 0.30)
; (defvar generate-convert-chance 0.10)
(defvar generate-get-local-chance 0.50)

(defun generate-body (webassembly-symbol-table subnodes)
	(let ((chances (list generate-operator-chance generate-get-local-chance)))
		(let ((pos (choose-by-chances chances)))
			(cond ((eql pos 0)
					(generate-operator webassembly-symbol-table subnodes))
				  ((eql pos 1)
				  	(generate-get-local webassembly-symbol-table))
				  (t (error-notification "undefined body generate"))
			)
		)
	)
)

; ****************************************************************************************************

(defun get-node-parameters (node)
	(cond ((eql (type-of node) 'operator-node)
	      	   (get-operator-parameters node))
	      ((eql (type-of node) 'get-local-node)
		       '())
	      ((eql (type-of node) 'convert-node)
	      	   (get-convert-parameters node))
		  (t '())
    )
)

; ****************************************************************************************************

(defun get-node-return-type (node webassembly-symbol-table)
	(cond ((eql (type-of node) 'operator-node)
	      	   (get-operator-return-type node))
	      ((eql (type-of node) 'get-local-node)
		       (get-local-return-type node webassembly-symbol-table))
	      ((eql (type-of node) 'convert-node)
	      	   (get-convert-return-type node))
		  (t '())
    )
)