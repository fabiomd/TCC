(in-package #:wao)

(defvar actions (list "SWAP" "RM" "ADD"))
(defvar body-nodes (list 'operator-node 'convert-node))
(defvar swap-chance 0.33)
(defvar rm-chance 0.34)
(defvar add-chance 0.33)

(defun webassembly-mutate (node)
	(let ((chances (list swap-chance rm-chance add-chance)))
		(let ((pos (choose-by-chances chances)))
			(let ((action (nth pos actions)))
				(apply-action node action)
			)
		)
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
			  (block-params (get-block-parameters body)))
		    (let ((chosen (choose block-params)))
				(let ((temp-locals (get-nodes-with-type (subseq block-params 0 (cdr chosen)) 'local-node)))
					(with-slots (params locals results) sub-webassembly-symbols-table
						(setf params (create-symbols temp-params)
							  results (create-symbols temp-results)
							  locals (create-symbols temp-locals)
						)
					)
					(let ((new-body-node (apply-action-body (car chosen) action sub-webassembly-symbols-table 0)))
						(if new-body-node
							(if (> (length block-params) 0)
								(setf (nth (cdr chosen) (slot-value body 'body)) new-body-node)
								(setf (slot-value body 'body) (list new-body-node))
							)
							(setf (slot-value body 'body) (rm-nth (cdr chosen) block-params))
						)
					)
				)
			)
		)
	)
)

; *******************************************************************************************

(defun apply-action-body (node action webassembly-symbols-table tree-lvl)
	(if (eql tree-lvl 20)
		(let ((chosen (choose sub-nodes)))
    		(let ((node-with-action (apply-action-body (car chosen) action sub-webassembly-symbols-table (+ tree-lvl 1))))
    			node-with-action
    		)
    	)
		(let ((sub-webassembly-symbols-table (copy-webassembly-symbols-table webassembly-symbols-table))
			   (sub-nodes (get-node-parameters node)))
		    (if node
		    	(let ((expected-return-type (get-node-return-type node webassembly-symbols-table)))
		    		(set-results sub-webassembly-symbols-table (create-result-symbol-from-type expected-return-type))
		    	)
		    )
		    (if (AND (> (length sub-nodes) 0) (deeper node))
		    	(let ((chosen (choose sub-nodes)))
		    		(let ((node-with-action (apply-action-body (car chosen) action sub-webassembly-symbols-table (+ tree-lvl 1))))
		    			node-with-action
		    		)
		    	)
		    	(apply-action-node node sub-nodes action sub-webassembly-symbols-table)
		    )
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
	      	   (if (> (length available-nodes) 0)
		      	   (let ((choosen (choose available-nodes)))
			      	   	(let ((origin-type (get-node-return-type origin-node webassembly-symbols-table)))
		      	   	    	  (let ((adapted-node (adapt-node (car choosen) origin-type webassembly-symbols-table)))
		      	   	    	  	  (if adapted-node
				      	   	    	  adapted-node
				      	   	    	  origin-node
			      	   	    	  )
		      	   	    	  )
			      	   	)
			       )
			       nil
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

; *******************************************************************************************

(defun check-local-consistence (node webassembly-symbols-table)
	(if (eql (type-of node) 'local-node)
		(progn
			(with-slots (name typeop) node
				(let ((type (get-type-from-name name webassembly-symbols-table)))
					(if type
						(let ((availables-symbols (get-availables-inputs webassembly-symbols-table)))
							(let ((options (filter-symbols-for-type availables-symbols type-out)))
								(if (> (length options) 0)
									(let ((chosen (choose options)))
										(get-name-from-symbol (car chosen))
									)
									nil
								)
							)
						)
						nil
					)
				)
			)
		)
		nil
	)
)
