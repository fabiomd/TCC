(in-package #:wao)

(defclass scope-node (node)
  ((name     :initarg :name     :accessor name     :initform nil)))

; ****************************************************************************************************

(defun expand-scope (wat-code)
	(let ((scopeNode (make-instance 'scope-node)))
		(if (= (length wat-code) 2)
			(setf (slot-value scopeNode 'operator) (car wat-code)
				  (slot-value scopeNode 'name)     (cadr wat-code))
			(error-notification "undefined scope format")
		)
		scopeNode
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