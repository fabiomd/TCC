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
			(let ((temp-locals (get-nodes-with-type (subseq body 0 (cdr chosen)) 'set-local-node)))
				(with-slots (params locals results) sub-webassembly-symbols-table
					(setf params (create-symbols temp-params)
						  results (create-symbols temp-results)
						  locals temp-locals
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
	    (print node)
		(cond ((eql (type-of node) 'operator-node)
				    (set-results sub-webassembly-symbols-table (list (create-result-symbol-from-type (get-operator-return-type node)))))
		      ((eql (type-of node) 'get-local-node)
		      	    (set-results sub-webassembly-symbols-table (list (create-result-symbol-from-type (get-local-return-type node sub-webassembly-symbols-table)))))
		      ((eql (type-of node) 'convert-node)
		      	    (set-results sub-webassembly-symbols-table (list (create-result-symbol-from-type (get-convert-return-type node)))))
			  (t (error-notification "undefined action body"))
	    )
	    (if (deeper node)
	    	(let ((chosen (choose sub-nodes)))
	    		(setf (nth (cdr chosen) sub-nodes) (apply-action-body (car chosen) action sub-webassembly-symbols-table))
	    	)
		    (apply-action-node node sub-nodes action sub-webassembly-symbols-table)
	    )
    )
)

; *******************************************************************************************

(defun apply-action-node (node available-nodes action webassembly-symbols-table)
	(cond ((string= action "SWAP")
		       (let ((temp-body (generate-body webassembly-symbols-table available-nodes)))
		       	 (print "SWAP")
		       	 (print temp-body)
		       	 temp-body
		       ))
	      ((string= action "RM")
	      	   (let ((temp-body (generate-convert webassembly-symbols-table (choose available-nodes))))
		       	 (print "RM")
		       	 (print temp-body)
		       	 temp-body
		       ))
	      ((string= action "ADD")
		       (let ((temp-body (generate-body webassembly-symbols-table available-nodes)))
		       	 (print "ADD")
		       	 (print temp-body)
		       	 temp-body
		       ))
		  (t (error-notification "undefined action treatment"))
	)
)
