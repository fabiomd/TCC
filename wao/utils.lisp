(in-package #:wao)

; FILE S EXPRESSION METHODS 

; GET THE NTH ELEMENT IN A LIST
(defun get-nth (element xlist)
	(let ((idx 0))
		(catch 'get-nth
			(dolist (x xlist)
				(when (equal element x) (throw 'get-nth idx))
				(setq idx (1+ idx)))
			nil)
		)
)

(defun rm-last-element (list)
           (loop for l on list
                 while (rest l)
                 collect (first l)))

; READ S-EXPRESSION CODE FILE
(defun get-wat-file-s-expression (wat-filename)
	(with-open-file (file wat-filename
                  :direction :input)
	  (read file))
)


; REPLACE THE NODE ON THE PATH
(defun replacenode-atposition (tree node track)
	(if (listp tree)
		(if (listp track)
			(let ((pos (car track)))
				(list (replace tree 
					     (replacenode-atposition (nth pos tree) node (cdr track)) 
					     :start1 pos
				))
			)
			(if (= (length tree) track)
				node
				(replace tree
						 node
						 :start1 track)
			)
		)
		node
	)
)


; CALL THE FUNC TO REPLACE THE NODE FOLLOWING THE PATH
(defun replacenode (tree node track)
	(car (replacenode-atposition tree node track)))


; DRAW A RANDOM NODE AND RETURN IT WITH ITS PATH
(defun draw-node (tree)
	(if (listp tree)
		(let ((pos (random (+ (length tree) 1))))
			(if (= pos (length tree))
				(list tree (length tree))
				(let ((answer (draw-node (nth pos tree))))
					(list (car answer) (apply #'append (list pos) (cdr answer)))
				)
			)
		)
		(list tree 1)
	)
)


; TESTE AREA START

(defun choose-action (actions)
	(if (listp actions)
		(get-nth (random (length actions)) actions)
		(error-notification "choose-action must receives a list of actions")
	)
)

; TESTE AREA END

(defvar i32-base      "i32")
(defvar i64-base      "i64")
(defvar i32-operators (list "add" "sub"))
(defvar i64-operators (list "add" "sub"))


(defun i32-op (operator)
	(let ((pos (random (- (length i32-operators) 1))))
		(if (string= operator (nth pos i32-operators))
			(nth (+ 1 pos) i32-operators)
			(nth pos i32-operators)
		)
	)
)

(defun i64-op (operator)
	(let ((pos (random (- (length i64-operators) 1))))
		(if (string= operator (nth pos i64-operators))
			(nth (+ 1 pos) i64-operators)
			(nth pos i64-operators)
		)
	)
)

(defun swap (tree)
	(let ((node (string-upcase (nth (random (length tree)) tree))))
		(cond ((string= "i32.add" node)
		       (i32-op node))
	      ((string= "i64.add" node)
		       (i64-op node)))
	)
)

(defun swap-base (base op)
	(cond ((string= i32-base base)
		       (i32-op op))
	      ((string= i64-base base)
		       (i64-op op))
	      (t (error-notification "invalid base")))
)

(defun swap-base (op)
	(let ((base (car (split-sequence #\. op))))
		(cond
			((string= base i32-base) (i64-base))
			((string= base i64-base) (i32-base))
			(t (error-notification "invalid base"))
		)
	)
)

(defun testeee (node)
	(swap-node (car (split-sequence #\. node)) (cdr node))
)

; (print (testeee "i32.add"))
	; (pcase node
	; ; (case (intern node)
	; ; (switch (node :test #'equal)
	; 	("i32.add" (i32-op "i32.add"))
	; 	("i64.add" (i64-op "i64.add"))
	; )

; NOTIFICATIONS 

(defun notification (message)
	(format t "~a~%" message))

(defun progress-notification (message)
	(format t "~a ... " message))

(defun done-notification ()
	(format t "done ~%"))

(defun notification-with-step (message)
	(format t "STEP : ~a ~a~%" (incf *current-step*) message))

(defun progress-notification-with-step (message)
	(format t "step : ~a ~a ... " (incf *current-step*) message))

(defun error-notification (message)
	(error message))

; ********************************************************************************************

; CREATE A DEPENDECY BETWEEN NODES, NODE2 DEPENDS ON NODE 1, NODE1 HAS NODE2 AS DEPENDENTS
(defun add-dependency (node1 node2)
	(add-dependson  node2 node1)
	(add-dependents node1 node2)
)

(defun add-dependson (node dependency)
	(setf (slot-value node 'dependson) (append (slot-value node 'dependson) (list dependency)))
)

(defun add-dependents (node dependency)
	(setf (slot-value node 'dependents) (append (slot-value node 'dependents) (list dependency)))
)

; ********************************************************************************************

(defun get-signature-with-name (signatures name)
	(loop for signature in signatures do
		(if (eql (type-of signature) 'param)
			(if (compare-string (slot-value signature 'name) name)
				(signature)
			)
		)
	)
)

(defun get-signature-return (signatures)
	(loop for signature in signatures do
		(if (eql (type-of signature) 'result)
			(signature)
		)
	)
	nil
)

(defun compare-string (string1 string2)
	(eql (string-downcase (write-to-string string1)) (string-downcase (write-to-string string2)))
)

; ****************************************************************************************************

(defun format-operator (operator)
	(let ((string-op (string-downcase (write-to-string operator))))
		string-op
	)
)

(defun format-name (name)
	(let ((string-name (write-to-string name)))
		(if (stringp name)
			(string-downcase string-name)
			string-name
		)
	)
)

(defun generated-format-name (name)
	(let ((string-name (string-downcase (write-to-string name))))
		string-name
	)
)

(defun format-typeop (typeop)
	(let ((string-typeop (string-downcase (write-to-string typeop))))
		string-typeop
	)
)