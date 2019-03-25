(in-package #:wao)

(defclass local-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'LOCAL)
   (name      :initarg :name      :accessor name      :initform nil)
   (typeop    :initarg :typeop    :accessor typeop    :initform nil)))

; ****************************************************************************************************

(defun expand-local (wat-code)
	(let ((local-node (make-instance 'local-node)))
		(setf (slot-value local-node 'name) (cadr wat-code))
		(setf (slot-value local-node 'typeop) (caddr wat-code))
		local-node
	)
)

; ****************************************************************************************************

(defun retrieve-local (node)
	(let ((code ""))
		(with-slots (operator name typeop) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) " " (format-typeop typeop) ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-local (node)
	(with-slots (operator name typeop) node
		(let ((local-node (make-instance 'local-node
			:operator operator
			:name name
			:typeop typeop
			)))
			local-node
		)
	)
)

; ****************************************************************************************************

(defun generate-local ()
	(let ((new-local-node (make-instance 'local-node
							:name (generate-symbol-name)
							:typeop (generate-type)
						)))
		new-local-node		      
	)
)

; ****************************************************************************************************

(defun local-return-type ()
	(car *void-types*)
)

; ****************************************************************************************************

(defun local-parameters ()
	'()
)