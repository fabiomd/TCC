(in-package #:wao)

(defun retrieve-code (nodes)
	(let ((code "("))
		(loop for node in nodes do
			(setf code (concatenate 'string code (retrieve-node node) " "))
		)
		(setf code (concatenate 'string code ")"))
		code
	)
)

; ****************************************************************************************************

(defun retrieve-node (node)
	(let ((code ""))
		(cond ((eql (type-of node) 'func-node)
		      	   (retrieve-func node))
		      ((eql (type-of node) 'export-node)
			       (retrieve-export node))
		      ((eql (type-of node) 'memory-node)
			       (retrieve-memory node))
		      ((eql (type-of node) 'table-node)
			       (retrieve-table node))
		      ((eql (type-of node) 'module-node)
			       (retrieve-module node))
	    )
    )
)

; ****************************************************************************************************

(defun retrieve-module (node)
	(let ((code ""))
		(let ((operator (slot-value node 'operator)))
			(setf code (concatenate 'string (format-operator operator)))
			code
		)
	)
)

(defun retrieve-table (node)
	(let ((code ""))
		(with-slots (operator name typeop) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (format-typeop typeop) ")"))
			code
		)
	)
)

(defun retrieve-memory (node)
	(let ((code ""))
		(with-slots (operator name index) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (format-typeop index) ")"))
			code
		)
	)
)

(defun retrieve-export (node)
	(let ((code ""))
		(with-slots (operator name scope) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (retrieve-scope scope) ")"))
			code
		)
	)
)

(defun retrieve-func (node)
	(let ((code ""))
		(with-slots (operator name signature body) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (generated-format-name name) " " (retrieve-signatures signature) (retrieve-body body) ")"))
			code
		)
	)
)


; ****************************************************************************************************

(defun retrieve-scope (node)
	(let ((code ""))
		(with-slots (operator name) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (generated-format-name name) ")"))
			code
		)
	)
)

(defun retrieve-signatures (nodes)
	(let ((code ""))
		(loop for node in nodes do
			(setf code (concatenate 'string code (retrieve-signature node) " "))
		)
		code
	)
)

(defun retrieve-signature (node)
	(cond ((eql (type-of node) 'param)
	      	   (retrieve-param node))
	      ((eql (type-of node) 'result)
		       (retrieve-result node))
    )
)

; ****************************************************************************************************

(defun retrieve-body (node)
	(let ((code "(bodys)"))
		; (with-slots (operator name) node
		; 	(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) ")"))
		; 	code
		; )
		code
	)
)

; ****************************************************************************************************

(defun retrieve-param (node)
	(let ((code ""))
		(with-slots (typeop operator name) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (format-typeop typeop) ")"))
			code
		)
	)
)

(defun retrieve-result (node)
	(let ((code ""))
		(with-slots (typeop operator) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-typeop typeop) ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun format-operator (operator)
	(let ((string-op (string-downcase (write-to-string operator))))
		string-op
	)
)

(defun format-name (name)
	(let ((string-name (write-to-string name)))
		(if (stringp name)
			(string-downcase string-name)
			string-name
		)
	)
)

(defun generated-format-name (name)
	(let ((string-name (string-downcase (write-to-string name))))
		string-name
	)
)

(defun format-typeop (typeop)
	(let ((string-typeop (string-downcase (write-to-string typeop))))
		string-typeop
	)
)

; ****************************************************************************************************