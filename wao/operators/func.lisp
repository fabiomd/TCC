(in-package #:wao)

(defclass func-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'FUNC)
   (name      :initarg :name      :accessor name      :initform nil)
   (signature :initarg :signature :accessor signature :initform nil)
   (body      :initarg :body      :accessor body      :initform nil)))

; ****************************************************************************************************

(defun expand-func (wat-code)
	(let ((funcNode (make-instance 'func-node)))
		(setf (slot-value funcNode 'name)      (car wat-code)
			  (slot-value funcNode 'signature) (expand-signatures (cdr (rm-last-element wat-code)))
			  (slot-value funcNode 'body)      (expand-body       (list (nth (- (length wat-code) 1) wat-code))))
		funcNode
	)
)

; ****************************************************************************************************

(defun retrieve-func (node)
	(let ((code ""))
		(with-slots (operator name signature body) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (generated-format-name name) " " (retrieve-signatures signature) (retrieve-body body) ")"))
			code
		)
	)
)