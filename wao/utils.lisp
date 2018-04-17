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