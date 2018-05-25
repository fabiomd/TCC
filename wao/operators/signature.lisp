(in-package #:wao)

(defclass signature-node (node)
  ((typeop   :initarg :typeop   :accessor typeop   :initform nil)
   (operator :initarg :operator :accessor operator :initform nil)))

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

(defun retrieve-signatures (nodes)
	(let ((code ""))
		(loop for node in nodes do
			(setf code (concatenate 'string code (retrieve-signature node) " "))
		)
		code
	)
)

(defun retrieve-signature (node)
	(cond ((eql (type-of node) 'param)
	      	   (retrieve-param node))
	      ((eql (type-of node) 'result)
		       (retrieve-result node))
    )
)