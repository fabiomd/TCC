	(in-package #:wao)

(defun webassembly-crossover (nodeA nodeB)
	(let ((new-node (apply-crossover nodeA nodeB)))
		(setf nodeA new-node)
	)
)

(defun apply-crossover (nodeA nodeB)
	(cond ((and (eql (type-of nodeA) 'func-node) (eql (type-of nodeB) 'func-node))
		(apply-crossover-function nodeA nodeB))
		  (t (error-notification "undefined crossover action"))
	)
)

(defun apply-crossover-function (nodeA nodeB)
	(let ((body-A (slot-value nodeA 'body))
		  (body-B (slot-value nodeB 'body)))
	    (if (and (> (length body-A) 0) (> (length body-B) 0))
		    (let ((drawed-node (draw-node (car body-B))))
				(let ((new-body (apply-crossover-node (car body-A) drawed-node)))
					(setf body-A new-body)
				)
			)
			body-B
		)
	)
)

(defun apply-crossover-node (nodeA nodeB)
	(if (deeper nodeA)
		(let (sub-nodes (get-node-parameters nodeA))
			(if (> (length sub-nodes) 0)
				(let ((choosen (choose sub-nodes)))
					(let ((new-node (apply-crossover-node (car choosen) nodeB)))
						(setf (nth (cdr choosen) sub-nodes) new-node)
					)
				)
				nodeB
			)
		)
		nodeB
	)
)

; (let ((origin-type (get-node-return-type origin-node webassembly-symbols-table)))
; 	  (let ((adapted-node (adapt-node (car choosen) origin-type webassembly-symbols-table)))
; 	  	  (if adapted-node
; 	    	  adapted-node
; 	    	  origin-node
;     	  )
; 	  )
; )