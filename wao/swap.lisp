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

(defvar actions (list 'SWAP 'RM 'ADD))

(defun mutate (node)
	(let ((pos (length actions)))
		(let ((action (nth (random pos) actions)))
			(apply-action node action)
		)
	)
)

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