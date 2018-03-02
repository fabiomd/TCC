(in-package :goa)

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

;; FUNCTION TO WALK ON GENOME
(defun get-genome-at-position (pos wasm-p)
	(nth pos (wasm-perf-genome wasm-p))
)

;; SINZE WAT FILE WILL BE RETURNED AS A LIST, THIS FUNCTION TURNS IT INTO A SINGLE STRING
(defun concatenate-list( list )
  (format nil "~{~a~}" list))

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