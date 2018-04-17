(in-package #:wao)

(defclass node ()
  ((operator :initarg :operator :accessor operator :initform nil)))

; ****************************************************************************************************

(defclass scope-node (node)
  ((name     :initarg :name     :accessor name     :initform nil)))

; ****************************************************************************************************

; (module ...)
; ... represents a list of nodes
(defclass module-node (node)
  ((operator :initarg :operator :accessor operator :initform 'module)))

; (table 0 $1)
(defclass table-node (node)
  ((operator :initarg :operator :accessor operator :initform 'table)
   (name     :initarg :name     :accessor name     :initform nil)
   (type     :initarg :type     :accessor type     :initform nil)))

; (memory $0 1)
(defclass memory-node (node)
  ((operator :initarg :operator :accessor operator :initform 'memory)
   (name     :initarg :name     :accessor name     :initform nil)
   (index    :initarg :index    :accessor index    :initform nil)))
; (export "name" method)
; examples (func $0) (mdoule $0)
(defclass export-node (node)
  ((operator :initarg :operator :accessor operator :initform 'export)
   (name     :initarg :name     :accessor name     :initform nil)
   (scope    :initarg :scope    :accessor scope    :initform nil)))


; (func "name" signature body )
; body can be almost any node
(defclass func-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'func)
   (name      :initarg :name      :accessor name      :initform nil)
   (signature :initarg :signature :accessor signature :initform nil)
   (body      :initarg :body      :accessor body      :initform nil)))

; ****************************************************************************************************

; examples (param $0 i32) (local $1 i32) (result i32)
(defclass signature-node (node)
  ((type     :initarg :type     :accessor type     :initform nil)))

(defclass param (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'param)
   (name     :initarg :name     :accessor name     :initform nil)))

(defclass local (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'local)
   (name     :initarg :name     :accessor name     :initform nil)))

(defclass result (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'result)))

; ****************************************************************************************************

; i32.add funcall call ...
(defclass operation (node)
  ((parameters :initarg :parameters :accessor parameters :initform nil)))

; ****************************************************************************************************

(defun expand-module (wat-code)
	(let ((moduleNode (make-instance 'module-node)))
			module-node)
)

(defun expand-export (wat-code)
	(let ((exportNode (make-instance 'export-node)))
		(case (length wat-code)
			(2 (setf (slot-value exportNode 'scope) (expand-scope (cddar wat-code))))
			(3 (setf (slot-value exportNode 'name) (cdar wat-code)
					 (slot-value exportNode 'scope) (expand-scope (cddar wat-code))))
			(t (error-notification "undefined export format"))
		)
		exportNode
	)
)

(defun expand-func (wat-code)
	(let ((exportFunc (make-instance 'func-node)))
		(setf (slot-value exportFunc 'name) (cadr wat-code)
			  (slot-value exportFunc 'signature) (expand-scope (cdr (rm-last-element wat-code)))
			  (slot-value exportFunc 'body) (expand-scope (nth (- (length wat-code) 1) wat-code)))
		exportFunc
	)
)

; ****************************************************************************************************

(defun expand-scope (wat-code)
	(let ((scopeNode (make-instance 'scope-node)))
		(if (= (length wat-code) 2)
			(setf (slot-value scopeNode 'operator) (car wat-code)
				  (slot-value scopeNode 'name) (cdr wat-code))
			(error-notification "undefined scope format")
		)
		scopeNode
	)
)

; ****************************************************************************************************

(defun expand-param (wat-code)
	(let ((paramNode (make-instance 'param
		:name (cadr wat-code)
		:type (caddr wat-code))))
		paramNode
	)
)

(defun expand-result (wat-code)
	(let ((resultNode (make-instance 'result
		:name (cadr wat-code)
		:type (caddr wat-code))))
		resultNode
	)
)

; ****************************************************************************************************

(defun expand-signatures (wat-code)
	(let ((signatures '()))
		(loop for signature in wat-code do
			(cond ((string= "param" signature)
				     (setf signatures (append signatures (list (expand-param signature)))))
				  ((string= "result" signature)
				     (setf signatures (append signatures (list (expand-result signature)))))
				  (t (error-notification "undefined signature")))
		)
		signatures
	)
)

; ****************************************************************************************************

(defun expand (wat-code)
	(cond ((string= "func" operator)
	      	   (expand-func (cdr wat-code)))
	      ((string= "export" operator)
		       (expand-export (cdr wat-code)))
	      ((string= "module" operator)
		       (expand-module (cdr wat-code)))
	      (t (error-notification "undefined base")))
)

; ****************************************************************************************************

(defun generate-dependecy-graph (wat-code)
	(let ((wat-dependecy-graph '()))
		(loop for sub-code in wat-code do
			(setf wat-dependecy-graph (append wat-dependecy-graph (list (expand sub-code))))
		)
		wat-dependecy-graph
	)
)