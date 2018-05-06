(in-package #:wao)

; (error-notification "invalid function format")

(defun mutate-func (node)
	(with-slots (operator name signature body) node
		(let ((body-pos (random (length body))))

		)
	)
)

; (defun get-signature-return (nodes)
; 	(loop for node in nodes do
; 		(if (eql (type-of node) 'result)
; 			(node)
; 		)
; 	)
; 	(error-notification "missing result in function")
; )


; (defclass signature-node (node)
;   ((typeop   :initarg :typeop   :accessor typeop   :initform nil)
;    (operator :initarg :operator :accessor operator :initform nil)))

; (defclass param (signature-node)
;   ((operator :initarg :operator :accessor operator :initform 'PARAM)
;    (name     :initarg :name     :accessor name     :initform nil)))

; (defclass local (signature-node)
;   ((operator :initarg :operator :accessor operator :initform 'LOCAL)
;    (name     :initarg :name     :accessor name     :initform nil)))

; (defclass result (signature-node)
;   ((operator :initarg :operator :accessor operator :initform 'RESULT)))

; (defclass func-node (node)
;   ((operator  :initarg :operator  :accessor operator  :initform 'FUNC)
;    (name      :initarg :name      :accessor name      :initform nil)
;    (signature :initarg :signature :accessor signature :initform nil)
;    (body      :initarg :body      :accessor body      :initform nil)))