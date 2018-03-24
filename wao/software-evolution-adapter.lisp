(in-package #:wao)

; WEBASSEMBLY SOFTWARE OBJECT
(defclass webassembly-software (software)
  ((fitness :initarg :fitness :accessor fitness :initform nil)
   (testsuite :initarg :testsuite :accessor testsuite :initform nil)
   (genome :initarg :genome :accessor genome :initform nil)))

 ; COPY METHOD RECEIVES A SOFTWARE AND CREATE A COPY OF IT
(defmethod copy ((webassembly webassembly-software))
  (with-slots (fitness testsuite genome) webassembly
    (make-instance (type-of webassembly)
      :fitness fitness
      :testsuite testsuite
      :genome genome)))

(defmethod crossover (webassembly-software-A webassembly-software-B)

  )

(defmethod mutate (webassembly-software-A)
  
  )

; EXTRA METHODS

; PRINT THE OBJECTS OF THE SOFTWARE
(defmethod print-software ((webassembly webassembly-software))
    (with-slots (fitness testsuite genome) webassembly
	      (print fitness)
	      (print testsuite)
	      (print genome)))