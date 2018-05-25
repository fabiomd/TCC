(in-package #:wao)

(defclass get-local-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'GET_LOCAL)
   (name      :initarg :name      :accessor name      :initform nil)))

; ****************************************************************************************************

(defun expand-get-local (wat-code)
	(let ((get-local-node (make-instance 'get-local-node)))
		(setf (slot-value get-local-node 'name) (cadr wat-code))
		get-local-node
	)
)

; ****************************************************************************************************

(defun retrieve-get-local (node)
	(let ((code ""))
		(with-slots (operator name) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) ")"))
			code
		)
	)
)