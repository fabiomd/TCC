(in-package #:wao)

(defclass else-node (node)
  ((operator        :initarg :operator       :accessor operator        :initform 'ELSE)
   (operatorBlock   :initarg :operatorBlock  :accessor operatorBlock   :initform nil)))

; ****************************************************************************************************

(defun expand-else (wat-code)
	(let ((else-node (make-instance 'else-node)))
	    (setf (slot-value else-node 'operatorBlock) (expand-block (cdr wat-code)))
		else-node
	)
)

; ****************************************************************************************************

(defun retrieve-else (node)
	(let ((code ""))
		(with-slots (operator operatorBlock) node
			(print (retrieve-block operatorBlock))
			(setf code (concatenate 'string code "("  (format-operator operator)))
			(setf code (concatenate 'string code " "  (retrieve-block operatorBlock)))
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun generate-else (webassembly-symbol-table subnodes)
	(let ((else-node (make-instance 'else-node)))
		(setf (slot-value else-node 'operatorBlock) (generate-block webassembly-symbol-table subnodes))
	)
)

; ****************************************************************************************************

(defun copy-else (node)
	(with-slots (operator operatorBlock) node
		(let ((temp-block nil))
			(setf temp-block (copy-block operatorBlock))
			(let ((else-node (make-instance 'else-node
				:operator operator
				:operatorBlock temp-block
				)))
				else-node
			)
		)
	)
)

; ****************************************************************************************************

(defun get-else-return-type (node webassembly-symbol-table)
	(block-return-type (slot-value node 'operatorBlock) webassembly-symbol-table)
)

(defun get-else-parameters (node)
	(slot-value node 'operatorBlock)
)