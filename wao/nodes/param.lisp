(in-package #:wao)

(defclass param (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'PARAM)
   (name     :initarg :name     :accessor name     :initform nil)))

; ****************************************************************************************************

(defun expand-param (wat-code)
	(let ((paramNode (make-instance 'param
		:name   (cadr wat-code)
		:typeop (caddr wat-code))))
		paramNode
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

; ****************************************************************************************************

(defun copy-param (node)
	(with-slots (operator name typeop) node
		(let ((param-node (make-instance 'param
			:operator operator
			:name name
			:typeop typeop
			)))
			param-node
		)
	)
)