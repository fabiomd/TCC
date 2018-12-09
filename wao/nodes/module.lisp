
(in-package #:wao)

(defclass module-node (node)
  ((operator :initarg :operator :accessor operator :initform 'MODULE)
   (body     :initarg :body     :accessor body     :initform nil)))

; ****************************************************************************************************

(defun expand-module ()
	(let ((moduleNode (make-instance 'module-node)))
			moduleNode)
)

; ****************************************************************************************************

(defun retrieve-module (node)
	(let ((code ""))
		(let ((operator (slot-value node 'operator)))
			(setf code (concatenate 'string (format-operator operator)))
			code
		)
	)
)


; ****************************************************************************************************

(defun copy-module (node)
	(with-slots (operator body) node
		(let ((body-nodes '()))
			(loop for body-node in body do
				(cond ((eql (type-of body-node) 'func-node)
					       (setf body-nodes (append body-nodes (list (copy-func body-node)))))
				      ((eql (type-of body-node) 'export-node)
					       (setf body-nodes (append body-nodes (list (copy-export body-node)))))
				      ((eql (type-of body-node) 'memory-node)
					       (setf body-nodes (append body-nodes (list (copy-memory body-node)))))
				      ((eql (type-of body-node) 'table-node)
					       (setf body-nodes (append body-nodes (list (copy-table body-node))))))
			)
			(let ((module-node (make-instance 'module-node
				:operator operator
				:body body-nodes
				)))
				module-node
			)
		)
	)
)