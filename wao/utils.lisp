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

;; READ A WAT FILE
(defun get-wat-file (wat-filename)
  (with-open-file (stream wat-filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

; READ S-EXPRESSION CODE FILE
(defun get-wat-file-s-expression (wat-filename)
	(with-open-file (file wat-filename
                  :direction :input)
	  (read file))
)

(defun replacenode (tree node)
	(if (listp tree)
		(let ((pos (random (+ (length tree) 1))))
			(if (= pos (length tree))
				node
				(replace tree (list (replacenode (nth pos tree) node)) :start1 pos)
			)
		)
		node
	)
)

(defun gettrack (treeA treeB)
	(if (listp tree)
		(let ((pos (random (+ (length tree) 1))))
			(if (= pos (length tree))
				(nconc a (list pos))
				(gettrack )
			)
		)
		(nconc a (list pos))
	)
	(nconc a (list 5))
)

(defun get-node (node)
	(if listp node)
	(if (or (equal (length node) 1) (< (random 100) 30)) 
		node 
		(get-node (nth (random (length node)) node))
	)
)

; NOTIFICATIONS 

(defun notification (message)
	(print message))

(defun notification-with-step (message)
	(print (concatenate 'string "STEP : " (write-to-string (incf *current-step*))))
	(notification message))