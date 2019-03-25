(in-package #:wao)

; ****************************************************************************************************

(defun expand-body (wat-code)
	(let ((body-node '()))
		(loop for body in wat-code do
			(cond ((check-operator (write-to-string (car body)))
				     (setf body-node (append body-node (list (expand-operator body)))))
				  ((string= "GET_LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-get-local body)))))
				  ((string= "SET_LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-set-local body)))))
				  ((string= "LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-local body)))))
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
			      ((eql (type-of node) 'set-local-node)
				       (setf code (concatenate 'string code " " (retrieve-set-local node))))
			      ((eql (type-of node) 'local-node)
				       (setf code (concatenate 'string code " " (retrieve-local node))))
			      ((eql (type-of node) 'convert-node)
			      	   (setf code (concatenate 'string code " " (retrieve-convert node))))
				  (t (progn 
				  	(print nodes)
				  	(print node)
				  	(error-notification "undefined body retrieve method")))
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
			      ((eql (type-of node) 'set-local-node)
			      	   (setf code (append code (list (copy-set-local node)))))
			      ((eql (type-of node) 'local-node)
			      	   (setf code (append code (list (copy-local node)))))
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
(defvar generate-get-local-chance 0.50)
(defvar generate-set-local-chance 0.20)
(defvar generate-local-chance 0.20)

(defun generate-body (webassembly-symbol-table subnodes)
	(let ((chances (list generate-operator-chance 
						 generate-get-local-chance 
						 generate-set-local-chance
						 generate-local-chance)))
		(let ((pos (choose-by-chances chances)))
			(let ((generated-node
				(cond ((eql pos 0)
						(generate-operator webassembly-symbol-table subnodes))
					  ((eql pos 1)
					  	(generate-get-local webassembly-symbol-table))
					  ((eql pos 2)
					  	(generate-set-local webassembly-symbol-table subnodes))
					  ((eql pos 3)
					  	(generate-local))
					  (t (error-notification "undefined body generate"))
				)))
			    (if generated-node
			    	generated-node
			    	(generate-body webassembly-symbol-table subnodes)
			    )
			)
		)
	)
)

; ****************************************************************************************************

(defun get-node-parameters (node)
	(cond ((eql (type-of node) 'operator-node)
	      	   (get-operator-parameters node))
	      ((eql (type-of node) 'get-local-node)
		       (get-local-parameters))
	      ((eql (type-of node) 'set-local-node)
		       (set-local-parameters node))
	      ((eql (type-of node) 'convert-node)
	      	   (get-convert-parameters node))
	      ((eql (type-of node) 'local-node)
	      	   (local-parameters))
		  (t '())
    )
)

; ****************************************************************************************************

(defun get-node-return-type (node webassembly-symbol-table)
	(cond ((eql (type-of node) 'operator-node)
	      	   (get-operator-return-type node))
	      ((eql (type-of node) 'get-local-node)
		       (get-local-return-type node webassembly-symbol-table))
	      ((eql (type-of node) 'set-local-node)
		       (set-local-return-type))
	      ((eql (type-of node) 'convert-node)
	      	   (get-convert-return-type node))
	      ((eql (type-of node) 'local-node)
	      	   (local-return-type))
		  (t (car *void-types*))
    )
)


(defun count-body-nodes (nodes)
	(if (listp nodes)
		(let ((counter 1))
			(loop for node in nodes do
				(setf counter (+ counter 1 (count-node-parameters node)))
			)
			counter
		)
		(count-node-parameters nodes)
	)
)

(defun count-node-parameters (node)
	(let ((counter 1))
		(let ((parameters (get-node-parameters node)))
			(loop for param in parameters do
				(setf counter (+ counter 1 (count-body-nodes param)))
			)
		)
		counter
	)
)