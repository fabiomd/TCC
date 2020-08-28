(in-package #:wao)

(defclass loop-node (node)
  ((operator        :initarg :operator          :accessor operator        :initform 'LOOP)
   (parameters      :initarg :parameters        :accessor parameters      :initform nil)
   (breakCondition  :initarg :breakCondition    :accessor breakCondition  :initform nil)
   (breakLoop       :initarg :breakLoop         :accessor breakLoop       :initform nil)))

; ****************************************************************************************************

(defun expand-loop (wat-code)
	(let ((loop-node (make-instance 'loop-node)))
		(let ((temp-parameters '()))
			(loop for param in (cdr wat-code) do
				(let ((param-node (expand-body (list param))))
					(cond ((eql (type-of (car param-node)) 'break-if-node)
			      	          (setf (slot-value loop-node 'breakCondition) (car param-node)))
			              ((eql (type-of (car param-node)) 'break-node)
				              (setf (slot-value loop-node 'breakLoop) (car param-node)))
			              (t
			              	  (setf temp-parameters (append temp-parameters param-node))))
				)
			)
			(setf (slot-value loop-node 'parameters) temp-parameters)
		)
		loop-node
	)
)

; ****************************************************************************************************

(defun retrieve-loop (node)
	(let ((code ""))
		(with-slots (operator parameters breakCondition breakLoop) node
			(setf code (concatenate 'string code "(" (format-operator operator)))
			(loop for temp in parameters do
				(setf code (concatenate 'string code " " (retrieve-body (list temp))))
			)
			(setf code (concatenate 'string code " " (retrieve-body (list breakCondition))))
			(setf code (concatenate 'string code " " (retrieve-body (list breakLoop))))
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-loop (node)
	(with-slots (operator parameters breakCondition breakLoop) node
		(let ((temp-parameters '()))
			(loop for parameter in parameters do
				(setf temp-parameters (append temp-parameters (copy-body (list parameter))))
			)
			(let ((operator-node (make-instance 'loop-node
				:operator operator
				:parameters temp-parameters
				:breakCondition (car (copy-body (list breakCondition)))
				:breakLoop (car (copy-body (list breakLoop)))
				)))
				operator-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-loop (webassembly-symbol-table subnodes)
	(let ((temp-parameters '())
	    (webassembly-symbol-table-copy (copy-webassembly-symbols-table webassembly-symbol-table)))
		(set-results webassembly-symbol-table-copy (create-result-symbol-from-type (read-from-string (car temp-type))))
		(loop for i from 0 to 1 do
			(setf temp-parameters (append temp-parameters (list (generate-body webassembly-symbol-table-copy subnodes))))
		)
		(let ((new-loop-node (make-instance 'loop-node
									:operator (read-from-string (car temp-operator))
									:parameters temp-parameters
									:breakCondition (generate-break-if webassembly-symbol-table subnodes)
									:breakCondition (generate-break webassembly-symbol-table subnodes)
								)))
		     new-loop-node
		)
	)
)

; ****************************************************************************************************

(defun get-loop-return-type ()
	(car *void-types*)
)

; ****************************************************************************************************

(defun get-loop-parameters (node)
	(with-slots (operator parameters breakCondition breakLoop) node
		(let ((temp-parameters '()))
			(let ((temp-parameters '()))
				(setf temp-parameters (append temp-parameters parameters (list breakCondition) (list breakLoop)))
			)
			temp-parameters
		)
	)
)