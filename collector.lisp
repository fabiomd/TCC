(in-package #:wao)

(defclass experiment-data ()
  ((name         :initarg :name         :accessor name         :initform nil)
   (fitness      :initarg :fitness      :accessor fitness      :initform nil)
   (bonus        :initarg :bonus        :accessor bonus        :initform nil)
   (size         :initarg :size         :accessor size         :initform nil)
   (testtable    :initarg :testtable    :accessor testtable    :initform nil)))

; ****************************************************************************************************

(defun check-data ()
	(if (eql (mod *fitness-evals* 100) 0)
		(progn
			(let ((best (get-best-element)))
				(collect-experiment-data best "best" *fitness-evals*)
			)
			(let ((worth (get-worth-element)))
				(collect-experiment-data worth "worth" *fitness-evals*)
			)

			(if *collector-debugger-is-enabled*
	  	  		(get-best)
	  	  	)
  	  	)
	)
	(if (eql *fitness-evals* *max-avaliations*)
		(progn
			(get-avaliations)
			(get-randomkey)
			(if *collector-debugger-is-enabled*
	  	  		(get-best)
	  	  	)
			(print "evolution completed")
		)
	)
)
; ****************************************************************************************************

(defun get-randomkey()
	(let ((path "./temp/")
	    (name "randomKey")
	    (extension ".txt"))
	    (add-to-file path name extension (write-to-string *random-state*))
	)
)

; ****************************************************************************************************

(defun get-avaliations()
	(let ((avaliations (retrieve-avaliations))
		(path "./temp/")
	    (name "populationData")
	    (extension ".txt"))
	     (add-to-file path name extension avaliations)
	)
)

; ****************************************************************************************************

(defun collect-experiment-data (element name executions)
     (let ((element-data (retrieve-data element))
     	   (element-plot (retrieve-graph-data element))
     	   (path "./temp/")
     	   (name (concatenate 'string name "GenerationData"))
     	   (graph (concatenate 'string name "GenerationDataAsPoints"))
     	   (extension ".txt"))
          (let ((content (concatenate 'string (format-data executions) " & " element-data " \\\\ \\n")))
          	  (add-to-file path name extension content)
          )
          (let ((content (concatenate 'string "(" (format-data executions) "," element-plot ")")))
          	  (add-to-file path graph extension content)
          )
     )
)

; ****************************************************************************************************

(defun retrieve-avaliations()
	(let ((data ""))
		(loop for individual in *population* do
			(setf data (concatenate 'string data (retrieve-data (retrieve-experiment-data individual)) " \\n"))
		)
		data
	)
)

; ****************************************************************************************************

(defun retrieve-graph-data (webassembly-software)
	(let ((data ""))
		(with-slots (fitness) webassembly-software
			(setf data (concatenate 'string data (format-data fitness)))
			data
		)
	)
)

; ****************************************************************************************************

(defun retrieve-data (webassembly-software)
	(let ((data ""))
		(with-slots (name fitness bonus size) webassembly-software
			(setf data (concatenate 'string data (format-data name) " & "))
			(setf data (concatenate 'string data (format-data fitness) " & "))
			(setf data (concatenate 'string data (format-data bonus) " & "))
			(setf data (concatenate 'string data (format-data size)))
			data
		)
	)
)

; ****************************************************************************************************

(defun format-data (data)
	(let ((string-data (write-to-string data)))
		(if (stringp data)
			(string-downcase string-data)
			string-data
		)
	)
)

; ****************************************************************************************************

(defun get-best-element ()
	(let ((best *original*))
		(loop for individual in *population* do
			(if (> (slot-value individual 'fitness) (slot-value best 'fitness))
				(setf best individual)
            ) 
        )
        (retrieve-experiment-data best)
    )
)

(defun get-worth-element ()
	(let ((worth *original*))
		(loop for individual in *population* do
			(if (> (slot-value individual 'fitness) (slot-value worth 'fitness))
				(setf worth individual)
			)  
        )
        (retrieve-experiment-data worth)
    )
)

(defun retrieve-experiment-data (webassembly-software)
	(let ((size (code-size webassembly-software)))
    	(with-slots (id fitness testtable genome) webassembly-software
    		(let ((experiment-data (make-instance 'experiment-data
    		    :name id
    		    :fitness fitness
    		    :bonus (fitness-size-bonus size)
    		    :size size
    		    :testtable testtable)))
    		experiment-data
    		)
        )
    )
)