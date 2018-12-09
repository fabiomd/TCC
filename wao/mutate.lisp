(in-package #:wao)

(defvar actions (list "SWAP" "RM" "ADD"))
(defvar body-nodes (list 'operator-node 'convert-node))

(defun webassembly-mutate (node)
	(let ((action (choose actions)))
		(apply-action node (car action))
	)
)

; *******************************************************************************************

(defun apply-action (node action)
	(let ((symbol-table (make-instance 'webassembly-symbols-table)))
		(cond ((eql (type-of node) 'func-node)
			(apply-action-function node action symbol-table))
			  (t (error-notification "undefined apply action"))
		)
	)
)

; *******************************************************************************************

(defun apply-action-function (node action webassembly-symbols-table)
	(with-slots (operator name signature body) node
		(let ((temp-params  (get-nodes-with-type signature 'param))
			  (temp-results (get-nodes-with-type signature 'result))
			  (sub-webassembly-symbols-table (copy-webassembly-symbols-table webassembly-symbols-table))
			  (chosen (choose body)))
			(let ((temp-locals (get-nodes-with-type (subseq body 0 (cdr chosen)) 'local-node)))
				(with-slots (params locals results) sub-webassembly-symbols-table
					(setf params (create-symbols temp-params)
						  results (create-symbols temp-results)
						  locals (create-symbols temp-locals)
					)
				)
				(let ((new-body-node (apply-action-body (car chosen) action sub-webassembly-symbols-table)))
					(setf (nth (cdr chosen) body) new-body-node)
				)
			)
		)
	)
)

; *******************************************************************************************

(defun apply-action-body (node action webassembly-symbols-table)
	(let ((sub-webassembly-symbols-table (copy-webassembly-symbols-table webassembly-symbols-table))
		   (sub-nodes (get-node-parameters node)))
	    (if node
			(cond ((eql (type-of node) 'operator-node)
					    (set-results sub-webassembly-symbols-table (create-result-symbol-from-type (get-operator-return-type node))))
			      ((eql (type-of node) 'get-local-node)
			      	    (set-results sub-webassembly-symbols-table (create-result-symbol-from-type (get-local-return-type node sub-webassembly-symbols-table))))
			      ((eql (type-of node) 'convert-node)
			      	    (set-results sub-webassembly-symbols-table (create-result-symbol-from-type (get-convert-return-type node))))
			      ((eql (type-of node) 'set-local-node)
			      	    (set-results sub-webassembly-symbols-table (create-result-symbol-from-type (set-local-return-type))))
			      ((eql (type-of node) 'local-node)
			      	    (set-results sub-webassembly-symbols-table (create-result-symbol-from-type (local-return-type))))
				  (t (error-notification "undefined action body"))
		    )
	    )
	    (if (AND (> (length sub-nodes) 0) (deeper node))
	    	(let ((chosen (choose sub-nodes)))
	    		(setf (nth (cdr chosen) sub-nodes) (apply-action-body (car chosen) action sub-webassembly-symbols-table))
	    	)
		    (apply-action-node node sub-nodes action sub-webassembly-symbols-table)
	    )
    )
)

; *******************************************************************************************

(defun apply-action-node (origin-node available-nodes action webassembly-symbols-table)
	(cond ((string= action "SWAP")
		       (let ((temp-body (generate-body webassembly-symbols-table available-nodes)))
		       	 temp-body
		       ))
	      ((string= action "RM")
	      	   (let ((choosen (choose available-nodes)))
		      	   	(let ((origin-type (get-node-return-type origin-node webassembly-symbols-table)))
	      	   	    	  (let ((adapted-node (adapt-node (car choosen) origin-type webassembly-symbols-table)))
	      	   	    	  	  (if adapted-node
			      	   	    	  adapted-node
			      	   	    	  origin-node
		      	   	    	  )
	      	   	    	  )
		      	   	)
		       ))
	      ((string= action "ADD")
	      	   (let ((add-available-nodes (append available-nodes (list origin-node))))
			       (let ((temp-body (generate-body webassembly-symbols-table add-available-nodes)))
			       	 temp-body
			       )
		       ))
		  (t (error-notification "undefined action treatment"))
	)
)
