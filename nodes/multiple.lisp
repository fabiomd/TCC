(in-package #:wao)

(defclass multiple-node (node)
  ((body    :initarg :body :accessor body :initform '())))

; ****************************************************************************************************

(defun expand-multiple (wat-code)
	(let ((multiple-node (make-instance 'multiple-node)))
		(let ((temp-body '()))
			(setf temp-body (expand-body wat-code))
			(setf (slot-value multiple-node 'body) temp-body)
		)
		multiple-node
	)
)

; ****************************************************************************************************

(defun retrieve-multiple (node)
	(let ((code ""))
		(with-slots (body) node
			(setf code (retrieve-body body))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-multiple (node)
	(with-slots (body) node
		(let ((temp-body '()))
			(setf temp-body (append temp-body (copy-body body)))
			(let ((multiple-node (make-instance 'multiple-node
				:body temp-body
				)))
				multiple-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-multiple (webassembly-symbol-table subnodes)
	(let ((multiple-node (make-instance 'multiple-node)))
		(setf (slot-value multiple-node 'body) (list (generate-body webassembly-symbol-table subnodes)))
	    multiple-node
	)
)

; ****************************************************************************************************

(defun multiple-return-type (node webassembly-symbol-table)
	(let ((type (car *void-types*)))
		(loop for body-node in (slot-value node 'body) do
			(let ((body-return-type (get-node-return-type body-node webassembly-symbol-table)))
				(if (not (find (string-downcase body-return-type) *void-types*   :test #'equal))
					(progn
					    (setf type body-return-type)
					    (return-from multiple-return-type type)
					)
				)
			)
		)
		(return-from multiple-return-type type)
	)
)

; ****************************************************************************************************

(defun get-multiple-parameters (node)
	(slot-value node 'body)
)