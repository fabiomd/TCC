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

; ;; READ A WAT FILE
; (defun get-wat-file (wat-filename)
;   (with-open-file (stream wat-filename)
;     (loop for line = (read-line stream nil)
;           while line
;           collect line)))

; READ S-EXPRESSION CODE FILE
(defun get-wat-file-s-expression (wat-filename)
	(with-open-file (file wat-filename
                  :direction :input)
	  (read file))
)

; (defun replacenode (tree node)
; 	(if (listp tree)
; 		(let ((pos (random (+ (length tree) 1))))
; 			(if (= pos (length tree))
; 				node
; 				(replace tree (list (replacenode (nth pos tree) node)) :start1 pos)
; 			)
; 		)
; 		node
; 	)
; )

; (defun replacenode-atposition (tree node)
; 	(if (listp tree)
; 		(if (listp (cdr node))
; 			(let ((pos (cadr node)))
; 				(if (= pos (length tree))
; 					(car node)
; 					(replace tree (list (replacenode-atposition (nth pos tree) (cons (car node) (cddr node)))) :start1 pos)
; 				)
; 			)
; 			(if (= (cdr node) (length tree))
; 				(car node)
; 				(let ((pos (cdr node)))
; 					(replace tree (car node) :start1 pos)
; 				)
; 			)
; 		)
; 		(car node)
; 	)
; )


; (defun replacenode-atposition (tree node)
; 	(if (listp tree)
; 		(if (listp (cdr node))
; 			(let ((pos (cadr node)))
; 				(replace 
; 					tree
; 					(replacenode-atposition 
; 						(nth pos tree) 
; 						(list (car node) (cddr node))
; 					) 
; 					:start1 pos
; 				)
; 			)
; 			(if (= (cdr node) (length tree))
; 				(if (listp (car node))
; 					(car node)
; 					(list (car node))
; 				)
; 				(replace tree (car node) :start1 (cdr node))
; 			)
; 		)
; 		(if (listp (car node))
; 			(car node)
; 			(list (car node))
; 		)
; 		; (car node)
; 	)
; )

; RECEIVES A TREE AND A NODETRACK IN THE FORM OF (MODULE (1 5 6 ...))
; (defun replacenode-atposition (tree node)
; 	(if (listp tree)
; 		(if (listp (car (cdr node)))
; 			(let ((pos (caadr node)))
; 				(let ((temppath (car (cdr node))))
; 					(replace 
; 						tree
; 						(replacenode-atposition 
; 							(nth pos tree) 
; 							(list (car node) (cdr temppath))
; 						) 
; 						:start1 pos
; 					)
; 				)
; 			)
; 			(if (= (car (cdr node)) (length tree))
; 				(if (listp (car node))
; 					(car node) 
; 					(list (car node))
; 				)
; 				(let ((post (car (cdr node))))
; 					(replace 
; 						tree
; 						(if (listp (car node))
; 							(car node) 
; 							(list (car node))
; 						)
; 						:start1 pos
; 					)
; 				)
; 			)
; 		)
; 		(if (listp (car node))
; 			(car node)
; 			(list (car node))
; 		)
; 	)
; )

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
		; (error "~S Invalid tree format." tree)
	)
)


(defun getnode (tree)
	(if (listp tree)
		(let ((pos (random (+ (length tree) 1))))
			(if (= pos (length tree))
				(list tree (length tree))
				(let ((answer (getnode (nth pos tree))))
					(list (car answer) (apply #'append (list pos) (cdr answer)))
				)
			)
		)
		(list tree 1)
	)
)

; (defun gettrack (treeA treeB)
; 	(if (listp tree)
; 		(let ((pos (random (+ (length tree) 1))))
; 			(if (= pos (length tree))
; 				(nconc a (list pos))
; 				(gettrack )
; 			)
; 		)
; 		(nconc a (list pos))
; 	)
; 	(nconc a (list 5))
; )	

; (defun get-node (node)
; 	(if listp node)
; 		(if (or (equal (length node) 1) (< (random 100) 30)) 
; 			node 
; 			(get-node (nth (random (length node)) node))
; 		)
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
	(format t message))