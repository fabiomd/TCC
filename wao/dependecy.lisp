(in-package #:wao)

(defun generate-dependecy-graph (wat-code)
	(if (string= (car wat-code) "MODULE")
		(let ((wat-dependecy-graph (list (expand-module))))
			(loop for sub-code in (cdr wat-code) do
				(setf wat-dependecy-graph (append wat-dependecy-graph (list (expand sub-code))))
			)
			wat-dependecy-graph
		)
		(error-notification "require module")
	)
)

(defun write-code (wat-code)
	(retrieve-code wat-code)
)