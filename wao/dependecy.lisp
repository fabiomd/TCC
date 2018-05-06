(in-package #:wao)

; ****************************************************************************************************

(defclass generic-dependecy-node ()
  ((operator :initarg :operator :accessor operator :initform nil)
   (dependents  :initarg :dependents  :accessor dependents  :initform '())))
   ; (line        :initarg :line        :accessor line        :initform 0)))

(defclass root-dependecy-node (generic-dependecy-node)
  ((operator :initarg :operator :accessor operator :initform 'ROOT)
   (dependents  :initarg :dependents  :accessor dependents  :initform '())))

(defclass dependecy-node (generic-dependecy-node)
  ((operator :initarg :operator :accessor operator :initform nil)
   (dependson   :initarg :dependson   :accessor dependson   :initform '())
   (dependents  :initarg :dependents  :accessor dependents  :initform '())))

; ****************************************************************************************************

(defun generate-signature-func-dependecy (wat-code-graph dependecy)
	(let ((func-dependecy (make-instance 'dependecy-node
		:operator 'FUNC)))
	    (add-dependency dependecy func-dependecy)
		(with-slots (name signature body) wat-code-graph
			(loop for sign in signature do
				(cond ((eql (type-of sign) 'param)
					     (add-dependency func-dependecy (make-instance 'dependecy-node :operator 'PARAM))
					  )
				      ((eql (type-of sign) 'result)
				      	 (add-dependency func-dependecy (make-instance 'dependecy-node :operator 'RESULT))
					  ))
			)
			; (generate-body-func-dependecy wat-code-graph func-dependecy)
		)
	)
)

(defun generate-body-func-dependecy (wat-code-graph dependecy)
	(with-slots (name signature body) wat-code-graph
		(if body
			(let ((func-result (get-signature-return (signature))))
				(loop for sub-code in body do
					(cond ((eql (type-of sub-code) 'get-local-node)
							(print "local")
						  )
					)
				)
			)
		)
	)
)

; (defun get-signature-with-name (signatures)
; 	(loop for signature in signatures do
; 		(if (eql (type-of signature) 'param)
; 			(if (eql (string-downcase )))
; 			(signature)
; 		)
; 	)
; )

; ; get-local-node

; (defun get-signature-return (signatures)
; 	(loop for signature in signatures do
; 		(if (eql (type-of signature) 'result)
; 			(signature)
; 		)
; 	)
; 	nil
; )
; (defclass func-node (node)
;   ((operator  :initarg :operator  :accessor operator  :initform 'FUNC)
;    (name      :initarg :name      :accessor name      :initform nil)
;    (signature :initarg :signature :accessor signature :initform nil)
;    (body      :initarg :body      :accessor body      :initform nil)))