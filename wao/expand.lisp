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
			  (slot-value funcNode 'body)      (expand-body       (list (nth (- (length wat-code) 1) wat-code))))
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
	(let ((body-node '()))
		(loop for body in wat-code do
			(cond ((check-operator (write-to-string (car body)))
				     (setf body-node (append body-node (list (expand-operator body)))))
				  ((string= "GET_LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-get-local body)))))
				  (t (error-notification "undefined body operator")))
		)
		body-node
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

(defun check-operator (wat-code)
	(let ((temp (split-sequence #\. wat-code)))
		(if (and (listp temp) (> (length temp) 1))
			(and (find (string-downcase (car temp))  *value-types* :test #'equal)
				 (find (string-downcase (cadr temp)) *operators*   :test #'equal)
			)
			nil
		)
	)
)

; ****************************************************************************************************

; BODY

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

(defun expand-get-local (wat-code)
	(let ((get-local-node (make-instance 'get-local-node)))
		(setf (slot-value get-local-node 'name) (cadr wat-code))
		get-local-node
	)
)

; ****************************************************************************************************

(defun make-operator (wat-code)
	(let ((operator (make-instance 'operator-node)))
		(let ((temp (split-sequence #\. wat-code)))
			(let ((temptype (find (string-downcase (car temp)) *value-types* :test #'equal)))
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

(defun expand (wat-code)
	(let ((operator (car wat-code)))
		(cond ((string= "FUNC" operator)
		      	   (expand-func   (cdr wat-code)))
		      ((string= "EXPORT" operator)
			       (expand-export (cdr wat-code)))
		      ((string= "MEMORY" operator)
			       (expand-memory (cdr wat-code)))
		      ((string= "TABLE" operator)
			       (expand-table (cdr wat-code)))
		      (t (error-notification "undefined base")))
	)
)