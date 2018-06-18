(in-package #:wao)

(defclass operator-node (node)
  ((typeop      :initarg :typeop      :accessor typeop      :initform nil)
   (parameters  :initarg :parameters  :accessor parameters  :initform nil)))

; ****************************************************************************************************

(defun expand-operator (wat-code)
	(let ((operator (make-operator (write-to-string (car wat-code)))))
		(let ((temp-parameters '()))
			(loop for param in (cdr wat-code) do
				(setf temp-parameters (append temp-parameters (list (expand-body (list param)))))
			)
			(setf (slot-value operator 'parameters) temp-parameters)
		)
		operator
	)
)

; ****************************************************************************************************

(defun retrieve-operator (node)
	(let ((code ""))
		(with-slots (typeop operator parameters) node
			(setf code (concatenate 'string code "(" (format-typeop typeop) "." (format-operator operator)))
			(loop for temp in parameters do
				(setf code (concatenate 'string code " " (retrieve-body temp)))
			)
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-operator (node)
	(with-slots (typeop operator parameters) node
		(let ((temp-parameters '()))
			(loop for parameter in parameters do
				(setf temp-parameters (append temp-parameters (list (copy-body parameter))))
			)
			(let ((operator-node (make-instance 'operator-node
				:typeop typeop
				:operator operator
				:parameters temp-parameters
				)))
				operator-node
			)
		)
	)
)

; ****************************************************************************************************
; UTILS
; ****************************************************************************************************

(defun check-operator (wat-code)
	(let ((temp (split-sequence #\. wat-code)))
		(if (and (listp temp) (> (length temp) 1))
			(and (find (string-downcase (car temp))  (append *i-value-types* *f-value-types*) :test #'equal)
				 (or (or (find (string-downcase (cadr temp)) *i-32-operators*   :test #'equal)
					     (find (string-downcase (cadr temp)) *i-64-operators*   :test #'equal)
					 )
					 (or (find (string-downcase (cadr temp)) *f-32-operators*   :test #'equal)
					 	 (find (string-downcase (cadr temp)) *f-64-operators*   :test #'equal)
					 )
				 )
			)
			nil
		)
	)
)

(defun make-operator (wat-code)
	(let ((operator (make-instance 'operator-node)))
		(let ((temp (split-sequence #\. wat-code)))
			(let ((temptype (find (string-downcase (car temp)) (append *i-value-types* *f-value-types*) :test #'equal)))
				(if temptype
					(progn
						(setf (slot-value operator 'typeop)   (intern (car temp)))
						(setf (slot-value operator 'operator) (intern (cadr temp)))
					)
				)
			)
		)
		operator
	)
)

; ****************************************************************************************************

(defun generate-operator (webassembly-symbol-table subnodes)
	(let ((temp-type (choose (append *i-value-types* *f-value-types*))))
		(let ((temp-operator nil))
			(cond ((string= (string-upcase (car temp-type)) "I32")
				(setf temp-operator (choose *i-32-operators*)))
				  ((string= (string-upcase (car temp-type)) "I64")
				(setf temp-operator (choose *i-64-operators*)))
				  ((string= (string-upcase (car temp-type)) "F32")
				(setf temp-operator (choose *f-32-operators*)))
				  ((string= (string-upcase (car temp-type)) "F64")
				(setf temp-operator (choose *f-64-operators*)))
			)
			(let ((temp-parameters '()))
				(loop for i from 0 to 1 do
					(setf temp-parameters (append temp-parameters (list (generate-body webassembly-symbol-table subnodes))))
				)
				(make-instance 'operator-node
					:typeop (read-from-string (car temp-type))
					:operator (read-from-string (car temp-operator))
					:parameters (list temp-parameters)
				)
			)
		)
	)
)

; ****************************************************************************************************

(defun get-operator-return-type (node)
	(slot-value node 'typeop)
)

(defun get-operator-parameters (node)
	(slot-value node 'parameters)
)