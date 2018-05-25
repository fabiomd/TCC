(in-package #:wao)

(defclass set-local-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'SET_LOCAL)
   (name      :initarg :name      :accessor name      :initform nil)))

; ****************************************************************************************************

(defun expand-set-local (wat-code)
	(let ((get-local-node (make-instance 'set-local-node)))
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