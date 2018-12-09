(in-package #:wao)

(defclass set-local-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'SET_LOCAL)
   (name      :initarg :name      :accessor name      :initform nil)
   (parameters  :initarg :parameters  :accessor parameters  :initform nil)))

; ****************************************************************************************************

(defun expand-set-local (wat-code)
	(let ((set-local-node (make-instance 'set-local-node)))
		(let ((name (nth 1 wat-code)))
			(setf (slot-value set-local-node 'name) 
				(if (stringp name)
					(read-from-string name)
					name
				)
			)
		)
		(let ((code-param (nth 2 wat-code))
			(temp-parameters '()))
			(if (and (listp code-param) (> (length code-param) 0))
				(progn
					(loop for param in code-param do
						(print param)
						(setf temp-parameters (append temp-parameters (expand-body (list param))))
					)
					(setf (slot-value set-local-node 'parameters) temp-parameters)
				)
				(setf (slot-value set-local-node 'parameters) code-param)
			)
		)
		set-local-node
	)
)

; ****************************************************************************************************

(defun retrieve-set-local (node)
	(let ((code ""))
		(with-slots (operator name parameters) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name)))
			(if (listp parameters)
				(loop for temp in parameters do
					(setf code (concatenate 'string code " " (retrieve-body (list temp))))
				)
				(setf code (concatenate 'string code " " parameters))
			)
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun generate-set-local (webassembly-symbol-table sub-nodes)
	(let ((temp-parameters '())
		   (webassembly-symbol-table-copy (copy-webassembly-symbols-table webassembly-symbol-table)))
		(loop for i from 0 to 1 do
			(setf temp-parameters (append temp-parameters (list (generate-body webassembly-symbol-table-copy subnodes))))
		)
		(let ((new-set-local-node (make-instance 'set-local-node
									:name (generate-symbol-name)
									:parameters temp-parameters
								)))
			new-set-local-node		      
		)
	)
)

; ****************************************************************************************************

(defun copy-set-local (node)
	(with-slots (operator name parameters) node
		(let ((temp-parameters '()))
			(if (listp parameters)
				(loop for parameter in parameters do
					(setf temp-parameters (append temp-parameters (copy-body (list parameter))))
					(setf temp-parameters parameters)
				)
			)
			(let ((set-local-node (make-instance 'set-local-node
				:operator operator
				:name name
				:parameters temp-parameters
				)))
				set-local-node
			)
		)
	)
)

; ****************************************************************************************************

(defun set-local-return-type ()
	(car *void-types*)
)

; ****************************************************************************************************

(defun set-local-parameters (node)
	(slot-value node 'parameters)
)