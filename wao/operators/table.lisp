(in-package #:wao)

(defclass table-node (node)
  ((operator :initarg :operator :accessor operator :initform 'TABLE)
   (name     :initarg :name     :accessor name     :initform nil)
   (typeop   :initarg :typeop   :accessor typeop   :initform nil)))

; ****************************************************************************************************

(defun expand-table (wat-code)
	(let ((tableNode (make-instance 'table-node)))
		(setf (slot-value tableNode 'name)  (car wat-code)
			  (slot-value tableNode 'typeop) (cadr wat-code))
		tableNode
	)
)

; ****************************************************************************************************

(defun retrieve-table (node)
	(let ((code ""))
		(with-slots (operator name typeop) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (format-typeop typeop) ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-table (node)
	(with-slots (operator name typeop) node
		(let ((table-node (make-instance 'table-node
			:operator operator
			:name name
			:typeop typeop
			)))
			table-node
		)
	)
)