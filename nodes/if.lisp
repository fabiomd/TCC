(in-package #:wao)

(defclass if-node (node)
  ((operator        :initarg :operator          :accessor operator        :initform 'IF)
   (result          :initarg :result            :accessor result          :initform nil)
   (ifCondition     :initarg :ifCondition       :accessor ifCondition     :initform nil)
   (thenOperator    :initarg :thenOperator      :accessor thenOperator    :initform nil)
   (elseOperator    :initarg :elseOperator      :accessor elseOperator    :initform nil)))

; ****************************************************************************************************

(defun expand-if (wat-code)
	(let ((if-node (make-instance 'if-node)))
		(setf (slot-value if-node 'result)    (expand-body (list (nth 1 wat-code))))
	    (setf (slot-value if-node 'ifCondition) (expand-body (list (nth 2 wat-code))))
	    (setf (slot-value if-node 'thenOperator) (expand-body (list (nth 3 wat-code))))
	    (if (nth 4 wat-code)
	    	(setf (slot-value if-node 'elseOperator) (expand-body (list (nth 4 wat-code))))
	    )
		if-node
	)
)

; ****************************************************************************************************

(defun retrieve-if (node)
	(let ((code ""))
		(with-slots (operator result ifCondition thenOperator elseOperator) node
			(setf code (concatenate 'string code "(" (format-operator operator)))
			(if result
				(setf code (concatenate 'string code " "  (retrieve-body result)))
			)
			(setf code (concatenate 'string code " "  (retrieve-body ifCondition)))
			(setf code (concatenate 'string code " "  (retrieve-body thenOperator)))
			(if elseOperator
				(setf code (concatenate 'string code " " (retrieve-body elseOperator)))
			)
			(setf code (concatenate 'string code ")"))
			code
		)
	)
)

; ****************************************************************************************************

(defun copy-if (node)
	(with-slots (operator result ifCondition thenOperator elseOperator) node
		(let ((temp-result nil)
			  (temp-condition nil)
			  (temp-then-operator nil)
			  (temp-else-operator nil))
		    (if result
		    	(setf temp-result (copy-body result))
		    )
			(setf temp-condition (copy-body ifCondition))
			(setf temp-then-operator (copy-body thenOperator))
			(if elseOperator
				(setf temp-else-operator (copy-body elseOperator))
			)
			(let ((if-node (make-instance 'if-node
				:result result
				:operator operator
				:ifCondition temp-condition
				:thenOperator temp-then-operator
				:elseOperator temp-else-operator
				)))
				if-node
			)
		)
	)
)

; ****************************************************************************************************

(defun generate-if (webassembly-symbol-table subnodes)
	(let ((if-node (make-instance 'if-node))
		  (then-return-type nil)
		  (else-return-type nil))
		(setf (slot-value if-node 'ifCondition) (list (generate-body webassembly-symbol-table subnodes)))
	    (setf (slot-value if-node 'thenOperator) (list (generate-then webassembly-symbol-table subnodes)))
	    (setf then-return-type (get-node-return-type (slot-value if-node 'thenOperator) webassembly-symbol-table))
	    (let ((shouldGenerateElse (choose (list 'T nil))))
	    	(if (cdr shouldGenerateElse)
	    		(setf (slot-value if-node 'elseOperator) (list (generate-else webassembly-symbol-table subnodes)))
	    		(setf else-return-type (get-node-return-type (slot-value if-node 'elseOperator) webassembly-symbol-table))
	    	)
	    	(let ((void-return (find (string-downcase then-return-type) *void-types* :test #'equal)))
	    		(if (and (not void-return)
	    		         (not (eql then-return-type nil))
	    	             (eql then-return-type else-return-type))
	    	        (setf (slot-value if-node 'result) (generate-result-with-type then-return-type))
	    	    )
	    	)
	    	if-node
	    )
	)
)

; ****************************************************************************************************

(defun get-if-return-type (node webassembly-symbol-table)
	(if (slot-value node 'result)
		(get-node-return-type (slot-value node 'result) webassembly-symbol-table)
		(car *void-types*)
	)
)

(defun get-if-parameters (node)
	(with-slots (operator result ifCondition thenOperator elseOperator) node
		(let ((parameters-node '()))
			(if result
				(setf parameters-node (append parameters-node result))
			)
			(setf parameters-node (append parameters-node ifCondition))
			(setf parameters-node (append parameters-node thenOperator))
			(if elseOperator
				(setf parameters-node (append parameters-node elseOperator))
			)
			parameters-node
		)
	)
)