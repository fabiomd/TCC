(in-package #:wao)

(defclass then-node (node)
  ((operator         :initarg :operator           :accessor operator        :initform 'THEN)
   (operatorBlock    :initarg :operatorBlock      :accessor operatorBlock   :initform nil)))

; ****************************************************************************************************

(defun expand-then (wat-code)
	(let ((then-node (make-instance 'then-node)))
	    (setf (slot-value then-node 'operatorBlock) (expand-block (cdr wat-code)))
		then-node
	)
)

; ****************************************************************************************************

(defun retrieve-then (node)
	(let ((code ""))
		(with-slots (operator operatorBlock) node
			(setf code (concatenate 'string code "("  (format-operator operator)))
			(setf code (concatenate 'string code " "  (retrieve-block operatorBlock)))
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun generate-then (webassembly-symbol-table subnodes)
	(let ((then-node (make-instance 'then-node)))
		(setf (slot-value then-node 'operatorBlock) (generate-block webassembly-symbol-table subnodes))
	)
)

; ****************************************************************************************************

(defun copy-then (node)
	(with-slots (operator operatorBlock) node
		(let ((temp-block nil))
			(setf temp-block (copy-block operatorBlock))
			(let ((then-node (make-instance 'then-node
				:operator operator
				:operatorBlock temp-block
				)))
				then-node
			)
		)
	)
)

; ****************************************************************************************************

(defun get-then-return-type (node webassembly-symbol-table)
	(block-return-type (slot-value node 'operatorBlock) webassembly-symbol-table)
)

(defun get-then-parameters (node)
	(slot-value node 'operatorBlock)
)