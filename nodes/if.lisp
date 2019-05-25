(in-package #:wao)

(defclass if-node (node)
  ((operator     :initarg :operator       :accessor operator     :initform 'IF)
   (ifCondition  :initarg :ifCondition    :accessor ifCondition  :initform nil)
   (thenBlock    :initarg :thenBlock      :accessor thenBlock    :initform nil)
   (elseOperator :initarg :elseOperator   :accessor elseOperator :initform nil)))

; ****************************************************************************************************

(defun expand-if (wat-code)
	(let ((if-node (make-instance 'if-node)))
	    (setf (slot-value if-node 'thenBlock) (expand-body (list (nth 1 wat-code))))
	    (setf (slot-value if-node 'thenBlock) (expand-block (list (nth 2 wat-code))))
	    (if (nth 3 wat-code)
	    	(setf (slot-value if-node 'elseOperator) (expand-body (list (nth 3 wat-code))))
	    )
		if-node
	)
)

; (if (result i32)
;   (i32.lt_s
;     (get_local $x)
;     (get_local $y)
;   )
;   (then
;     (i32.const 10)
;   )
;   (else
;     (i32.const 20)
;   )
; )  

; ****************************************************************************************************

(defun retrieve-if (node)
	(let ((code ""))
		(with-slots (operator ifCondition thenBlock elseOperator) node
			(setf code (concatenate 'string code "( " + (format-operator operator)))
			(setf code (concatenate 'string code " "  + (retrieve-body ifCondition)))
			(setf code (concatenate 'string code " "  + (retrieve-block thenBlock)))
			(if elseOperator
				(setf code (concatenate 'string code " " + (retrieve-body elseOperator)))
			)
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-if (node)
	(with-slots (operator ifCondition thenBlock elseOperator) node
		(let ((temp-condition nil)
			  (temp-then-block nil)
			  (temp-else-operator nil))
			(setf temp-condition (copy-body (list ifCondition)))
			(setf temp-then-block (copy-block (list thenBlock)))
			(setf temp-else-operator (copy-block (list elseOperator)))
			(let ((if-node (make-instance 'if-node
				:operator operator
				:ifCondition temp-condition
				:thenBlock temp-then-block
				:elseOperator temp-else-operator
				)))
				if-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-if (webassembly-symbol-table subnodes)
	(let ((if-node (make-instance 'if-node)))
		(setf (slot-value if-node 'ifCondition) (generate-body webassembly-symbol-table subnodes))
	    (setf (slot-value if-node 'thenBlock) (generate-block webassembly-symbol-table subnodes))
	    (let ((shouldGenerateElse (choose (list 'T nil))))
	    	(if (cdr shouldGenerateElse)
	    		(setf (slot-value if-node 'elseOperator) (generate-else webassembly-symbol-table subnodes))
	    	)
	    	if-node
	    )
	)
)

; ****************************************************************************************************

(defun get-if-return-type (node webassembly-symbol-table)
	(let ((then-return nil)
		  (else-return nil))
	    (setf then-return (block-return-type (slot-value node 'thenBlock) webassembly-symbol-table))
	    (if (slot-value node 'thenBlock)
	    	(setf else-return (get-else-return-type (slot-value node 'elseOperator) webassembly-symbol-table))
	    )
	    (if (eql then-return else-return)
	    	then-return
	    	(car *void-types*)
	    )
	)
	(slot-value node 'typeop)
)

(defun get-if-parameters (node)
	(with-slots (operator ifCondition thenBlock elseOperator) node
		(let ((parameters-node '()))
			(setf parameters-node (append parameters-node ifCondition))
			(setf parameters-node (append parameters-node thenBlock))
			(if elseOperator
				(setf parameters-node (append parameters-node elseOperator))
			)
			parameters-node
		)
	)
)