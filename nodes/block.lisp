(in-package #:wao)

(defclass block-node (node)
  ((operator    :initarg :operator   :accessor operator   :initform 'BLOCK)
   (parameters  :initarg :parameters :accessor parameters :initform '())))

; ****************************************************************************************************

(defun expand-block (wat-code)
	(let ((block-node (make-instance 'block-node)))
		(let ((temp-parameters '()))
			(loop for param in (cdr wat-code) do
				(setf temp-parameters (append temp-parameters (expand-body (list param))))
			)
			(setf (slot-value block-node 'parameters) temp-parameters)
		)
		block-node
	)
)

; ****************************************************************************************************

(defun retrieve-block (node)
	(let ((code ""))
		(with-slots (operator parameters) node
			(setf code (concatenate 'string "(" (format-operator operator) " "))
			(loop for temp in parameters do
				(setf code (concatenate 'string code " " (retrieve-body (list temp))))
			)
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-block (node)
	(with-slots (parameters) node
		(let ((temp-parameters '()))
			(loop for parameter in parameters do
				(setf temp-parameters (append temp-parameters (copy-body (list parameter))))
			)
			(let ((block-node (make-instance 'block-node
				:parameters temp-parameters
				)))
				block-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-block (webassembly-symbol-table subnodes)
	(let ((block-node (make-instance 'block-node))
		  (temp-parameters '()))
		(loop for i from 0 to 1 do
			(setf temp-parameters (append temp-parameters (list (generate-body webassembly-symbol-table-copy subnodes))))
		)
		(setf (slot-value block-node 'parameters) temp-parameters)
	    block-node
	)
)

; ****************************************************************************************************

(defun block-return-type (node webassembly-symbol-table)
	(let ((type (car *void-types*)))
		(loop for param in (slot-value node 'parameters) do
			(let ((body-return-type (get-node-return-type param webassembly-symbol-table)))
				(if (not (find (string-downcase body-return-type) *void-types*   :test #'equal))
					(progn
					    (setf type body-return-type)
					    (return-from block-return-type type)
					)
				)
			)
		)
		(return-from block-return-type type)
	)
)

; ****************************************************************************************************

(defun get-block-parameters (node)
	(slot-value node 'parameters)
)