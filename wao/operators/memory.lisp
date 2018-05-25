(in-package #:wao)

(defclass memory-node (node)
  ((operator :initarg :operator :accessor operator :initform 'MEMORY)
   (name     :initarg :name     :accessor name     :initform nil)
   (index    :initarg :index    :accessor index    :initform nil)))

; ****************************************************************************************************

(defun expand-memory (wat-code)
	(let ((memoryNode (make-instance 'memory-node)))
		(setf (slot-value memoryNode 'name)  (car wat-code)
			  (slot-value memoryNode 'index) (cadr wat-code))
		memoryNode
	)
)

; ****************************************************************************************************

(defun retrieve-memory (node)
	(let ((code ""))
		(with-slots (operator name index) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (format-typeop index) ")"))
			code
		)
	)
)