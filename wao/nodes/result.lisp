(in-package #:wao)

(defclass result (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'RESULT)))

; ****************************************************************************************************

(defun expand-result (wat-code)
	(let ((resultNode (make-instance 'result
		:typeop  (cadr wat-code))))
		resultNode
	)
)

; ****************************************************************************************************

(defun retrieve-result (node)
	(let ((code ""))
		(with-slots (typeop operator) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-typeop typeop) ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-result (node)
	(with-slots (operator typeop) node
		(let ((result-node (make-instance 'result
			:operator operator
			:typeop typeop
			)))
			result-node
		)
	)
)