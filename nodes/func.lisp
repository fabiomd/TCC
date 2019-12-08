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
			  (slot-value funcNode 'body)      (expand-multiple       body))
		funcNode
	)
)

; ****************************************************************************************************

(defun retrieve-func (node)
	(let ((code ""))
		(with-slots (operator name signature body) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (generated-format-name name) " " (retrieve-signatures signature) (retrieve-multiple body) ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-func (node)
	(with-slots (operator name signature body) node
		(let ((signature-node (copy-signatures signature))
			  (body-nodes (copy-multiple body)))
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

; ****************************************************************************************************

(defun get-func-name (node)
	(slot-value node 'name)
)

; ****************************************************************************************************

(defun get-func-return-type (node webassembly-symbol-table)
	(with-slots (name signature) node
		(loop for item in signature do
			(if (eql (type-of item) 'result)
				(return-from get-func-return-type (get-result-return-type item webassembly-symbol-table))
			)
		)
		(return-from get-func-return-type (car *void-types*))
	)
)

; ****************************************************************************************************

(defun get-func-parameters-type (node webassembly-symbol-table)
	(let ((parameters '()))
		(with-slots (name signature) node
			(loop for item in signature do
				(if (eql (type-of item) 'param)
					(setf parameters (append parameters (list (get-param-type item))))
				)
		    )
		    parameters
	    )
	)
)