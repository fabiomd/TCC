(in-package #:wao)

; ****************************************************************************************************
; FILE UTILS
; ****************************************************************************************************

(defun get-wat-file-s-expression (wat-filename)
	(with-open-file (file wat-filename
                  :direction :input)
	  (read file))
)

; ****************************************************************************************************
; FORMAT UTILS
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

; ****************************************************************************************************
; LIST UTILS
; ****************************************************************************************************

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

; ****************************************************************************************************
; MESSAGE UTILS
; ****************************************************************************************************

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

; ****************************************************************************************************
; STRING UTILS
; ****************************************************************************************************

(defun compare-string (string1 string2)
	(eql (string-downcase (write-to-string string1)) (string-downcase (write-to-string string2)))
)

; ****************************************************************************************************
; TREE UTILS
; ****************************************************************************************************

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

; ****************************************************************************************************
; SOFTWARE ADAPTER UTILS
; ****************************************************************************************************

; GIVE A LIST OF OPTIONS, CHOOSE A NEW VALUE, IF THERES NOT ENOUGH OPTIONS, RETURN THE OLDVALUE
(defun choose-new-value (oldValue options)
	(if (< (length options) 2)
		oldValue
		(let ((pos (random (- (length options) 1))))
			(let ((newValue (nth pos options)))
				(if (eql oldValue newValue)
					(setf newValue (nth (+ pos 1) options))
				)
				newValue
			)
		)
	)
)