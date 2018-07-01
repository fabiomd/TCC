(in-package #:wao)

(defclass get-local-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'GET_LOCAL)
   (name      :initarg :name      :accessor name      :initform nil)))

; ****************************************************************************************************

(defun expand-get-local (wat-code)
	(let ((get-local-node (make-instance 'get-local-node)))
		(setf (slot-value get-local-node 'name) (cadr wat-code))
		get-local-node
	)
)

; ****************************************************************************************************

(defun retrieve-get-local (node)
	(let ((code ""))
		(with-slots (operator name) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name) ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-get-local (node)
	(with-slots (operator name) node
		(let ((get-local-node (make-instance 'get-local-node
			:operator operator
			:name name
			)))
			get-local-node
		)
	)
)

; ****************************************************************************************************

(defun generate-get-local (webassembly-symbol-table)
	(let ((choosen-output (choose (get-expected-outputs webassembly-symbol-table))))
		(let ((type-out (get-type-from-symbol (car choosen-output))))
			(let ((options (filter-symbols-for-type (get-availables-inputs webassembly-symbol-table) type-out)))
				(let ((choosen-input (choose options)))
					(make-instance 'get-local-node
						:name (slot-value (car choosen-input) 'name)
					)
				)
			)
		)
	)
)

; ****************************************************************************************************

(defun get-local-return-type (node webassembly-symbol-table)
	(get-type-from-name (slot-value node 'name) webassembly-symbol-table)
)