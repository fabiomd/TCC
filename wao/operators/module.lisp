(in-package #:wao)

(defclass module-node (node)
  ((operator :initarg :operator :accessor operator :initform 'MODULE)
   (body     :initarg :body     :accessor body     :initform nil)))

; ****************************************************************************************************

(defun expand-module ()
	(let ((moduleNode (make-instance 'module-node)))
			moduleNode)
)

; ****************************************************************************************************

(defun retrieve-module (node)
	(let ((code ""))
		(let ((operator (slot-value node 'operator)))
			(setf code (concatenate 'string (format-operator operator)))
			code
		)
	)
)