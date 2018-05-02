(in-package #:wao)

(defun expand-module ()
	(let ((moduleNode (make-instance 'module-node)))
			moduleNode)
)

(defun expand-table (wat-code)
	(let ((tableNode (make-instance 'table-node)))
		(setf (slot-value tableNode 'name)  (car wat-code)
			  (slot-value tableNode 'typeop) (cadr wat-code))
		tableNode
	)
)

(defun expand-memory (wat-code)
	(let ((memoryNode (make-instance 'memory-node)))
		(setf (slot-value memoryNode 'name)  (car wat-code)
			  (slot-value memoryNode 'index) (cadr wat-code))
		memoryNode
	)
)

(defun expand-export (wat-code)
	(let ((exportNode (make-instance 'export-node)))
		(case (length wat-code)
			(1 (setf (slot-value exportNode 'scope) (expand-scope  (cadr wat-code))))
			(2 (setf (slot-value exportNode 'name)  (car wat-code)
					 (slot-value exportNode 'scope) (expand-scope  (cadr wat-code))))
			(t (error-notification "undefined export format"))
		)
		exportNode
	)
)

(defun expand-func (wat-code)
	(let ((funcNode (make-instance 'func-node)))
		(setf (slot-value funcNode 'name)      (car wat-code)
			  (slot-value funcNode 'signature) (expand-signatures (cdr (rm-last-element wat-code)))
			  (slot-value funcNode 'body)      (expand-body      (nth (- (length wat-code) 1) wat-code)))
		funcNode
	)
)

; ****************************************************************************************************

(defun expand-scope (wat-code)
	(let ((scopeNode (make-instance 'scope-node)))
		(if (= (length wat-code) 2)
			(setf (slot-value scopeNode 'operator) (car wat-code)
				  (slot-value scopeNode 'name)     (cadr wat-code))
			(error-notification "undefined scope format")
		)
		scopeNode
	)
)

; ****************************************************************************************************

(defun expand-param (wat-code)
	(let ((paramNode (make-instance 'param
		:name   (cadr wat-code)
		:typeop (caddr wat-code))))
		paramNode
	)
)

(defun expand-result (wat-code)
	(let ((resultNode (make-instance 'result
		:typeop  (cadr wat-code))))
		resultNode
	)
)

(defun expand-body (wat-code)
	(let ((bodyNode nil))
		; :typeop (caddr wat-code))))
		bodyNode
	)
)

; ****************************************************************************************************

(defun expand-signatures (wat-code)
	(let ((signatures '()))
		(loop for signature in wat-code do
			(cond ((string= "PARAM" (car signature))
				     (setf signatures (append signatures (list (expand-param  signature)))))
				  ((string= "RESULT" (car signature))
				     (setf signatures (append signatures (list (expand-result signature)))))
				  (t (error-notification "undefined signature")))
		)
		signatures
	)
)

; ****************************************************************************************************

(defun expand (wat-code)
	(let ((operator (car wat-code)))
		(cond ((string= "FUNC" operator)
		      	   (expand-func   (cdr wat-code)))
		      ((string= "EXPORT" operator)
			       (expand-export (cdr wat-code)))
		      ; ((string= "module" operator)
			       ; (expand-module ))
		      ((string= "MEMORY" operator)
			       (expand-memory (cdr wat-code)))
		      ((string= "TABLE" operator)
			       (expand-table (cdr wat-code)))
		      (t (error-notification "undefined base")))
	)
)