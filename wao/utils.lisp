(in-package #:wao)

; (setf *random-state* (make-random-state t))
; ****************************************************************************************************
; FILE UTILS
; ****************************************************************************************************

(defun get-wat-file-s-expression (wat-filename)
	(with-open-file (file wat-filename
                  :direction :input)
	  (read file))
)

(defun save-file (path name extension content)
	(let ((file-path (concatenate 'string path name extension)))
		(with-open-file (stream file-path 
			                    :direction :output
	                            :if-does-not-exist :create
	                            :if-exists :overwrite)
	      (format stream content))
	)
)

(defun generate-symbol () 
	(intern (symbol-name (gensym)))
)

(defun generate-type () 
	(let ((options (append *i-value-types* *f-value-types*)))
		(let ((chosen (choose options)))
			(car chosen)
		)
	)
)

; ****************************************************************************************************
; FORMAT UTILS
; ****************************************************************************************************

(defun format-symbol-type (symbol)
	(if (stringp symbol)
		(read-from-string symbol)
		symbol
	)
)

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
; PARSE UTILS
; ****************************************************************************************************

(defun parse-fitness (fitness)
	(with-input-from-string (in fitness)
	  (read in))
)

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
(defun draw-node (node)
	(if (deeper node)
		(let (sub-nodes (get-node-parameters node))
			(if (and (listp sub-nodes) (> (length sub-nodes) 0))
				(let ((choosen (choose sub-nodes)))
					(if (> (length (car choosen)) 0)
						(let ((temp-node (draw-node (caar choosen))))
							temp-node
						)
						node
					)
				)
				node
			)
		)
		node
	)
)

; ****************************************************************************************************
; SOFTWARE ADAPTER UTILS
; ****************************************************************************************************

; GIVE A LIST OF OPTIONS, CHOOSE A NEW VALUE, IF THERES NOT ENOUGH OPTIONS, RETURN THE OLDVALUE
(defun choose-new-value (old-value options)
	(if (< (length options) 2)
		old-value
		(let ((pos (random (- (length options) 1))))
			(let ((new-value (nth pos options)))
				(if (eql old-value new-value)
					(setf new-value (nth (+ pos 1) options))
				)
				new-value
			)
		)
	)
)

(defun choose (node)
	(if (eql (length node) 0)
			(cons '() 0)
		(let ((pos (random (length node))))
				(cons (nth pos node) pos)
		)
	)
)

(defun choose-by-chances (chances)
	(let ((temp-chances 0.0))
		(loop for chance in chances do
			(setf temp-chances (+ temp-chances chance))
		)
		(let ((temp-chance (random temp-chances))
			  (temp 0.0))
			(loop for pos from 0 to (length chances) do
				(setf temp (nth pos chances))
				(if (< temp-chance temp)
					(return pos)
				)
				(setf temp-chance (- temp-chance temp))
			)
		)
	)
)

; ****************************************************************************************************
; NODES UTILS
; ****************************************************************************************************


(defun get-nodes-with-type (nodes node-type)
	(let ((temp '()))
		(loop for node in nodes do
			(if (eql (type-of node) node-type)
				(setf temp (append temp (list node)))
			)
		)
		temp
	)
)

(defun get-signatures-by-identifiers (nodes node-ids)
	(let ((temp '()))
		(loop for node in nodes do
			(if (listp node)
				(loop for id in node-ids do
					(if (eql (car node) id)
						(setf temp (append temp (list node)))
					)
				)
			)
		)
		temp
	)
)

(defun get-signatures-did-not-match-identifiers (nodes node-ids)
	(let ((temp '()))
		(loop for node in nodes do
			(if (listp node)
				(let ((match-node nil))
					(loop for id in node-ids do
						(if (eql (car node) id)
							(setf match-node t)
						)
					)
					(if (not match-node)
						(setf temp (append temp (list node)))
					)
				)
			)
		)
		temp
	)
)

(defun has-type (results symbol)
	(loop for result in results do
		(if (eql (slot-value result 'typesym) (slot-value symbol 'typesym))
			t
		)
	)
	nil
)

; ****************************************************************************************************

(defun get-wat-code-with-type (wat-code wat-type)
	(let ((temp '()))
		(loop for node in nodes do
			(if (eql (type-of node) node-type)
				(setf temp (append temp (list node)))
			)
		)
		temp
	)
	(let ((match-code '()))
		(loop for body in wat-code do
			(cond ((check-operator (write-to-string (car body)))
				     (setf body-node (append body-node (list (expand-operator body)))))
				  ((string= "GET_LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-get-local body)))))
				  ((string= "SET_LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-set-local body)))))
				  ((string= "LOCAL" (car body))
				     (setf body-node (append body-node (list (expand-local body)))))
				  ((check-convert (write-to-string (car body)))
				  	 (setf body-node (append body-node (list (expand-convert body)))))
				  (t (error-notification "undefined body expand method"))
		    )
		)
		body-node
	)
)

(defun get-value-type (value)
	(cond ((stringp value)
      	   (t (error-notification "string type is not supported yet")))
      ((integerp value)
	       (nth (- (length *i-value-types*) 1) *i-value-types*))
      ((floatp value)
	       (nth (- (length *f-value-types*) 1) *f-value-types*))
	  (t (error-notification "undefined type"))
    )
)

; ****************************************************************************************************

; FALAR SOBRE A CHANCE DE EXPANCAO NA MONOGRAFIA, MODIFICAR VALORES PARA TESTE
; NON TERMINAL EXPRESSIONS
(defvar operator-deeper-chance  0.60)
(defvar convert-deeper-chance   0.60)
; TERMINAL EXPRESSIONS
(defvar get-local-deeper-chance 0.00)
(defvar set-local-deeper-chance 0.60)
(defvar local-deeper-chance 0.00)

(defun deeper-chance (node)
	(cond ((eql (type-of node) 'operator-node)
	      	   operator-deeper-chance)
	      ((eql (type-of node) 'get-local-node)
		       get-local-deeper-chance)
	      ((eql (type-of node) 'convert-node)
	      	   convert-deeper-chance)
	      ((eql (type-of node) 'set-local-node)
	      	   set-local-deeper-chance)
	      ((eql (type-of node) 'local-node)
	      	   local-deeper-chance)
		  (t 0.00)
    )
)

(defun deeper (node)
	(> (deeper-chance node) (random 1.0))
)

; ****************************************************************************************************

(defun get-type-from-node (node webassembly-symbol-tables)
	(cond ((eql (type-of node) 'operator-node)
		       (slot-value node 'typeop))
	      ((eql (type-of node) 'get-local-node)
		       (get-type-from-name (slot-value node 'name) webassembly-symbol-tables))
	      ((eql (type-of node) 'convert-node)
	      	   (slot-value node 'typeopout))
	      ((eql (type-of node) 'local-node)
	      	   (slot-value node 'typeop))
		  (t (error-notification "undefined node type from"))
    )
)