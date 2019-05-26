(in-package #:wao)

(defclass block-node (node)
  ((body    :initarg :body :accessor body :initform '())))

; ****************************************************************************************************

(defun expand-block (wat-code)
	(let ((block-node (make-instance 'block-node)))
		(let ((temp-body '()))
			(setf temp-body (expand-body wat-code))
			(setf (slot-value block-node 'body) temp-body)
		)
		block-node
	)
)

; ****************************************************************************************************

(defun retrieve-block (node)
	(print "block")
	(let ((code ""))
		(with-slots (body) node
			(print node)
			(print body)
			(setf code (retrieve-body body))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-block (node)
	(with-slots (body) node
		(let ((temp-body '()))
			(setf temp-body (append temp-body (copy-body body)))
			(let ((block-node (make-instance 'block-node
				:body temp-body
				)))
				block-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-block (webassembly-symbol-table subnodes)
	(let ((block-node (make-instance 'block-node)))
		(setf (slot-value block-node 'body) (generate-body webassembly-symbol-table subnodes))
	    block-node
	)
)

; ****************************************************************************************************

(defun block-return-type (node webassembly-symbol-table)
	(let ((type (car *void-types*)))
		(loop for body-node in (slot-value node 'body) do
			(let ((body-return-type (get-node-return-type body-node webassembly-symbol-table)))
				(if (not (find (string-downcase body-return-type) *void-types*   :test #'equal))
					(setf type body-return-type)
					(block nil (return type))
				)
			)
		)
		(block nil (return type))
	)
)

; ****************************************************************************************************

(defun block-parameters (node)
	(slot-value node 'body)
)