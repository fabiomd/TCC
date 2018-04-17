;;;; package.lisp

(defpackage #:wao
	(:use #:common-lisp
		  ; #:cl-ppcre
		  #:alexandria
	      #:curry-compose-reader-macros
	      #:split-sequence
	      #:software-evolution
	      #:software-evolution-utility))


; (defpackage #:wao
; 	(:use #:common-lisp
; 	      ; #:alexandria
; 	      ; #:metabang-bind
; 	      #:curry-compose-reader-macros
; 	      #:split-sequence
; 	      ; #:cl-store
; 	      ; #:cl-ppcre
; 	      ; #:bordeaux-threads
; 	      ; #:diff
; 	      ; #:delta-debug
; 	      #:software-evolution
; 	      #:software-evolution-utility))