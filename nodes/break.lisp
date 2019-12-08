(in-package #:wao)

(defclass break-node (node)
  ((operator     :initarg :operator     :accessor operator     :initform 'BR)
   (value        :initarg :value        :accessor value        :initform 0)))

; ****************************************************************************************************

(defun expand-break (wat-code)
	(let ((break-node (make-instance 'break-node)))
		(setf (slot-value break-node 'value) (cdr wat-code))
		break-node
	)
)

; ****************************************************************************************************

(defun retrieve-break (node)
	(let ((code ""))
		(with-slots (operator value) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-operator value)))
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-break (node)
	(with-slots (operator value) node
		(let ((break-node (make-instance 'break-node
			:operator operator
			:value value
			)))
			break-node
		)
	)
)

; ****************************************************************************************************

(defun generate-break (webassembly-symbol-table subnodes)
	(let ((break-node (make-instance 'break-node)))
		break-node
	)
)

; ****************************************************************************************************

(defun set-break-return-type ()
	(car *void-types*)
)

; ****************************************************************************************************

(defun set-break-parameters (node)
	'()
)