(in-package #:wao)

(defclass else-node (node)
  ((operator     :initarg :operator       :accessor operator    :initform 'ELSE)
   (thenBlock    :initarg :thenBlock      :accessor thenBlock   :initform nil)))

; ****************************************************************************************************

(defun expand-else (wat-code)
	(let ((else-node (make-instance 'else-node)))
	    (setf (slot-value else-node 'thenBlock) (expand-block (list (cdr wat-code))))
		else-node
	)
)

; ****************************************************************************************************

(defun retrieve-else (node)
	(let ((code ""))
		(with-slots (operator thenBlock) node
			(setf code (concatenate 'string code "( " + (format-operator operator)))
			(setf code (concatenate 'string code " " + (retrieve-block thenBlock)))
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun generate-else (webassembly-symbol-table subnodes)
	(let ((else-node (make-instance 'else-node)))
		(setf (slot-value else-node 'thenBlock) (generate-block webassembly-symbol-table subnodes))
	)
)

; ****************************************************************************************************

(defun copy-else (node)
	(with-slots (operator thenBlock) node
		(let ((temp-block nil))
			(setf temp-block (copy-block thenBlock))
			(let ((else-node (make-instance 'if-node
				:operator operator
				:thenBlock temp-block
				)))
				else-node
			)
		)
	)
)

; ****************************************************************************************************

(defun get-else-return-type (node webassembly-symbol-table)
	(block-return-type (slot-value node 'thenBlock) webassembly-symbol-table)
)

(defun get-else-parameters (node)
	(slot-value node 'thenBlock)
)