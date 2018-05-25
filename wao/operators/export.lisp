(in-package #:wao)

(defclass export-node (node)
  ((operator :initarg :operator :accessor operator :initform 'EXPORT)
   (name     :initarg :name     :accessor name     :initform nil)
   (scope    :initarg :scope    :accessor scope    :initform nil)))

; ****************************************************************************************************

(defun expand-export (wat-code)
	(let ((exportNode (make-instance 'export-node)))
		(case (length wat-code)
			(1 (setf (slot-value exportNode 'scope) (expand-scope  (cadr wat-code))))
			(2 (setf (slot-value exportNode 'name)  (car wat-code)
					 (slot-value exportNode 'scope) (expand-scope  (cadr wat-code))))
			(t (error-notification "undefined export format"))
		)
		exportNode
	)
)

; ****************************************************************************************************

(defun retrieve-export (node)
	(let ((code ""))
		(with-slots (operator name scope) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (retrieve-scope scope) ")"))
			code
		)
	)
)