(in-package #:wao)

(defclass func-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'FUNC)
   (name      :initarg :name      :accessor name      :initform nil)
   (signature :initarg :signature :accessor signature :initform nil)
   (body      :initarg :body      :accessor body      :initform nil)))

; ****************************************************************************************************

(defun expand-func (wat-code)
	(let ((funcNode (make-instance 'func-node))
		(signatures (get-signatures-by-identifiers wat-code (list 'PARAM 'RESULT)))
		(body (get-signatures-did-not-match-identifiers wat-code (list 'PARAM 'RESULT))))
		(setf (slot-value funcNode 'name)      (car wat-code)
			  (slot-value funcNode 'signature) (expand-signatures signatures)
			  (slot-value funcNode 'body)      (expand-block       body))
		funcNode
	)
)

; ****************************************************************************************************

(defun retrieve-func (node)
	(let ((code ""))
		(with-slots (operator name signature body) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (generated-format-name name) " " (retrieve-signatures signature) (retrieve-block body) ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-func (node)
	(with-slots (operator name signature body) node
		(let ((signature-node (copy-signatures signature))
			  (body-nodes (copy-block body)))
			(let ((func-node (make-instance 'func-node
				:operator operator
				:name name
				:signature signature-node
				:body body-nodes
				)))
				func-node
			)
		)
	)
)