(in-package #:wao)

(defclass call-node (node)
  ((operator     :initarg :operator     :accessor operator     :initform 'CALL)
   (name         :initarg :name         :accessor name         :initform nil)
   (parameters   :initarg :parameters   :accessor parameters   :initform nil)))

; ****************************************************************************************************

(defun expand-call (wat-code)
	(let ((call-node (make-instance 'call-node)))	
		(temp-parameters '())
		(setf (slot-value call-node 'name) (cadr wat-code))
		(loop for param in (cddr wat-code) do
			(setf temp-parameters (append temp-parameters (expand-body (list param))))
		)
		(setf (slot-value call-node 'parameters) temp-parameters)
		set-local-node
	)
	call-node
)

; ****************************************************************************************************

(defun retrieve-call (node)
	(let ((code ""))
		(with-slots (operator name parameters) node
			(setf code (concatenate 'string "(" (format-operator operator) " " (format-name name)))
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

(defun copy-call (node)
	(with-slots (operator name parameters) node
		(let ((temp-parameters '()))
			(loop for parameter in parameters do
				(setf temp-parameters (append temp-parameters (copy-body (list parameter))))
			)
			(let ((call-node (make-instance 'call-node
				:operator operator
				:name name
				:parameters temp-parameters
				)))
				call-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-call (webassembly-symbol-table)
	(let ((functions (get-availables-functions webassembly-symbol-table)))
		(let ((chosen (choose functions)))
		    (let ((temp-parameters '())
		    	(function (car chosen))
		    	(name (get-func-name function))
		    	(result (generate-result-with-type (get-func-return-type function webassembly-symbol-table)))
		    	(expected-parameters-types (get-func-parameters-type node webassembly-symbol-table)))
		        (loop for expected-parameter-type in expected-parameters-types do
		        	(let ((adapted-node (adapt-node (generate-body webassembly-symbol-table '()))))
		        		(setf temp-parameters (append temp-parameters (list adapt-node)))
		        	)
		        )
		        (let ((call-node (make-instance 'call-node
		        	               :name
		        	               :parameters temp-parameters
		        	               :result result)))
		        call-node
		        )
			)
		)
	)
)

; ****************************************************************************************************

(defun get-call-return-type (node webassembly-symbol-table)
	(get-type-from-name (slot-value node 'name) webassembly-symbol-table)
)

; ****************************************************************************************************

(defun get-call-parameters ()
	(slot-value node 'parameters)
)