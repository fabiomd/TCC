(in-package #:wao)

(defclass conversor-node (node)
  ((typeopin      :initarg :typeopin   :accessor typeopin   :initform nil)
   (typeopout     :initarg :typeopout  :accessor typeopout  :initform nil)
   (parameters    :initarg :parameters :accessor parameters :initform nil)))

; ****************************************************************************************************

(defun expand-conversor (wat-code)
	(let ((temp (split-sequence #\. (write-to-string (car wat-code)))))
		(let ((temp2 (split-sequence #\/ (write-to-string (cadr temp)))))
			(let ((conversor (make-instance 'conversor-node
				:typeopin  (car temp)
				:operator  (car temp2)
				:typeopout (cdar temp2))))
				(let ((temp-parameters '()))
					(setf temp-parameters (expand-body (cdr wat-code)))
					(setf (slot-value conversor 'parameters) temp-parameter)
				)
				conversor
			)
		)
	)
)

; ****************************************************************************************************

(defun retrieve-conversor (node)
	(let ((code ""))
		(with-slots (typeop operator parameters) node
			(setf code (concatenate 'string code "(" (format-typeop typeop) "." (format-operator operator) " "))
			(loop for temp in parameters do
				(setf code (concatenate 'string code " " (retrieve-body temp)))
			)
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun check-conversor (wat-code)
	(let ((temp (split-sequence #\. (write-to-string (car wat-code)))))
		(let ((temp2 (split-sequence #\. (write-to-string (cadr temp)))))
			(cond
				((eql  (write-to-string (cadr temp)) "WRAP")
				'T)
				((eql  (write-to-string (cadr temp)) "DEMOTE")
				'T)
				((eql  (write-to-string (cadr temp)) "PROMOTE")
				'T)
				((eql  (write-to-string (cadr temp)) "REINTERPRET")
				'T)
				((find (string-downcase (car temp2)) *trunc-operators*   :test #'equal)
				'T)
				((find (string-downcase (car temp2)) *extend-operators*  :test #'equal)
				'T)
				((find (string-downcase (car temp2)) *convert-operators* :test #'equal)
				'T)
				('T nil)
			)
		)
	)
)