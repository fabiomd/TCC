(in-package #:wao)

(defclass break-if-node (node)
  ((operator     :initarg :operator     :accessor operator     :initform 'BR_IF)
   (name         :initarg :name         :accessor name         :initform 1)
   (parameters   :initarg :parameters   :accessor parameters   :initform nil)))

; ****************************************************************************************************

(defun expand-break-if (wat-code)
	(let ((break-if-node (make-instance 'break-if-node))	
		(temp-parameters '()))
		(setf (slot-value break-if-node 'name) (cadr wat-code))
		(loop for param in (cddr wat-code) do
			(setf temp-parameters (append temp-parameters (expand-body (list param))))
		)
		(setf (slot-value break-if-node 'parameters) temp-parameters)
		break-if-node
	)
)

; ****************************************************************************************************

(defun retrieve-break-if (node)
	(let ((code ""))
		(with-slots (operator parameters) node
			(setf code (concatenate 'string "(" (format-operator operator)))
			(if (listp parameters)
				(loop for temp in parameters do
					(setf code (concatenate 'string code " " (retrieve-body (list temp))))
				)
				(setf code (concatenate 'string code " " (format-name parameters)))
			)
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-break-if (node)
	(with-slots (operator name parameters) node
		(let ((temp-parameters '()))
			(loop for parameter in parameters do
				(setf temp-parameters (append temp-parameters (copy-body (list parameter))))
			)
			(let ((break-if-node (make-instance 'break-if-node
				:operator operator
				:name name
				:parameters temp-parameters
				)))
				break-if-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-break-if (webassembly-symbol-table subnodes)
	(let ((temp-parameters '())
	    (webassembly-symbol-table-copy (copy-webassembly-symbols-table webassembly-symbol-table)))
		(set-results webassembly-symbol-table-copy (create-result-symbol-from-type (read-from-string (car temp-type))))
		(loop for i from 0 to 1 do
			(setf temp-parameters (append temp-parameters (list (generate-body webassembly-symbol-table-copy subnodes))))
		)
		(let ((new-break-if-node (make-instance 'break-if-node
									:operator (read-from-string (car temp-operator))
									:parameters temp-parameters
								)))
		     new-break-if-node
		)
	)
)

; ****************************************************************************************************

(defun set-break-if-return-type ()
	(car *void-types*)
)

; ****************************************************************************************************

(defun set-break-if-parameters (node)
	(slot-value node 'parameters)
)