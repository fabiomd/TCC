(in-package #:wao)

; (defun swap (wat-code)
; 	(let ((body-node '()))
; 		(loop for body in wat-code do
; 			(cond ((check-operator (write-to-string (car body)))
; 				     (setf body-node (append body-node (list (expand-operator body)))))
; 				  ((string= "GET_LOCAL" (car body))
; 				     (setf body-node (append body-node (list (expand-get-local body)))))
; 				  ((check-convert (write-to-string (car body)))
; 				  	 (setf body-node (append body-node (list (expand-convert body)))))
; 				  (t (error-notification "undefined body operator"))
; 		    )
; 		)
; 		body-node
; 	)
; )

; ****************************************************************************************************
(defun swap-typeop (typeop)
	(let ((new-value (choose-new-value typeop (append *i-value-types* *f-value-types*))))
		new-value
	)
)
; ****************************************************************************************************
(defun swap-operator (operator typeop)
	(cond ((string= (write-to-string typeop) "I32")
		(let ((i32-value (choose-new-value operator *i-32-operators*)))
			i32-value))
		  ((string= (write-to-string typeop) "I64")
		(let ((i64-value (choose-new-value operator *i-64-operators*)))
			i64-value))
		  ((string= (write-to-string typeop) "F32")
		(let ((f32-value (choose-new-value operator *f-32-operators*)))
			f32-value))
		  ((string= (write-to-string typeop) "F64")
		(let ((f64-value (choose-new-value operator *f-64-operators*)))
			f64-value))
	)
)

; ****************************************************************************************************
(defun swap-convert (typeop-in operator typeop-out)
	(let ((new-value (choose-new-value operator *convert-operators*)))
		new-value
	)
)
; ****************************************************************************************************

(defun adapt-operator (operator typeop)
	(cond ((string= (write-to-string typeop) "I32")
		(if (find (string-downcase operator) *i-32-operators* :test #'equal)
			operator
			(swap-operator operator typeop)
		))
		  ((string= (write-to-string typeop) "I64")
		(if (find (string-downcase operator) *i-64-operators* :test #'equal)
			operator
			(swap-operator operator typeop)
		))
		  ((string= (write-to-string typeop) "F32")
		(if (find (string-downcase operator) *f-32-operators* :test #'equal)
			operator
			(swap-operator operator typeop)
		))
		  ((string= (write-to-string typeop) "F64")
		(if (find (string-downcase operator) *f-64-operators* :test #'equal)
			operator
			(swap-operator operator typeop)
		))
	)
)

; ****************************************************************************************************
(defun apply-action (tree action)
	(let ((func-nodes '()))
		(loop for node in tree do
			(if (eql (type-of node) 'func-node)
				(setf func-nodes (append func-nodes node))
			)
		)
		(let ((pos (random (length func-nodes))))
			(apply-action-func (nth pos func-nodes) action)
		)
	)
)

(defun apply-action-func (node action)
	(with-slots (operator name signature body) node
		(apply-action-body body)
	)
)

(defun apply-action-body (node)
	(let ((pos (random (length node))))
	)
)

; ******************************************************************