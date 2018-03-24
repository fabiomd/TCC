(in-package #:wao)

; FILE S EXPRESSION METHODS 

;; FUNCTION TO READ LIST
(defun get-nth (element xlist)
	(let ((idx 0))
		(catch 'get-nth
			(dolist (x xlist)
				(when (equal element x) (throw 'get-nth idx))
				(setq idx (1+ idx)))
			nil)
		)
)

;; REDEFINITION OF FROM-FILE
(defun get-wat-file (wat-filename)
  (with-open-file (stream wat-filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

;; FUNCTION TO READ A WAT FILE
(defun get-wat-file (wat-filename)
  (with-open-file (stream wat-filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun get-wat-file-s-expression (wat-filename)
	(with-open-file (file wat-filename
                  :direction :input)
	  (read file))
)

; WEBASSEMBLY FITNESS

(defun webassembly-testsuite (test-script webassembly-wat-path)
	(let ((fitness-output-stream (make-string-output-stream)))
	    (uiop:run-program  (concatenate 'string "sh" " " test-script " " webassembly-wat-path) 
								:output fitness-output-stream
								:error :output 
								:error-output 
							  	:lines :ignore-error-status t)
	    (let ((result (get-output-stream-string fitness-output-stream)))
		    (block nil (return result))))
)

(defun webassembly-fitness (test-script webassembly-wat-path)
	(let ((result (webassembly-testsuite test-script webassembly-wat-path)))
		(let ((test-table (split-sequence:SPLIT-SEQUENCE #\Newline result :remove-empty-subseqs t)))
		(let ((fitness 0))
			(loop for x in test-table do
				(let ((temp (split-sequence:SPLIT-SEQUENCE #\space x :remove-empty-subseqs t)))
					(if (string-equal (car temp) "error")
						(progn
						  (if (string-equal (car temp) "true")
						      (progn 
								  (print "has failed")
								  (block nil (return (list (worst) test-table))))))
						(progn 
						  (setf fitness (+ fitness (parse-integer(caddr temp))))))
					)
				)
		(block nil (return (list fitness test-table)))))))

; #MUTATE METHODS

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

; (defmethod copy ((webassembly webassembly-software))
;   (with-slots (fitness testsuite genome) webassembly
;     (make-instance (type-of webassembly)
;       :fitness fitness
;       :testsuite testsuite
;       :genome genome)))