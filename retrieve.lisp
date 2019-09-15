(in-package #:wao)

(defun retrieve-code (wat-code)
	(let ((code "("))
		(if (eql (type-of wat-code) 'module-node)
			(let ((nodes (slot-value wat-code 'body)))
				(setf code (concatenate 'string code (retrieve-node wat-code) " "))
				(loop for node in nodes do
					(setf code (concatenate 'string code (retrieve-node node) " "))
				)
				(setf code (concatenate 'string code ")"))
				code
			)
		)
	)
)

(defun retrieve-node (node)
	(let ((code ""))
		(cond ((eql (type-of node) 'func-node)
		      	   (retrieve-func node))
		      ((eql (type-of node) 'export-node)
			       (retrieve-export node))
		      ((eql (type-of node) 'memory-node)
			       (retrieve-memory node))
		      ((eql (type-of node) 'table-node)
			       (retrieve-table node))
		      ((eql (type-of node) 'module-node)
			       (retrieve-module node))
	    )
    )
)