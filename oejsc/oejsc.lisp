;;;; oejsc.lisp

(in-package #:oejsc)
;; (ql:quickload :parse-js)
;; (use-package :parse-js)

;;; "oejsc" goes here. Hacks and glory await!

(defvar *code* nil)
(defvar *parsetree* nil)

(defun setcode (code)
  (setf *code* code))

(defun setptree (parsetree)
  (setf *parsetree* parsetree))

(defun oejsc (filename)
  (with-open-file (stream filename)
		  (let ((contents (make-string (file-length stream))))
		    (read-sequence contents stream)
		    (setcode contents))))
