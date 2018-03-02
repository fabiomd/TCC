(in-package :goa)

(define-software webassembly-wat-software (software)
  (testsuite :accessor testsuite :initform nil)
  (fitness :accessor fitness :initform nil)
 )

; (defclass software ()
;   ((fitness :initarg :fitness :accessor fitness :initform nil)))


(defclass orig-wasm-perf ()
	((fitness :accessor orig-wasm-perf-fitness)
	 (testsuite :accessor orig-wasm-perf-testsuite)
	 (genome :accessor orig-wasm-perf-genome))
)

(defclass wasm-perf ()
	((fitness :accessor wasm-perf-fitness)
	 (testsuite :accessor wasm-perf-testsuite)
	 (genome :accessor wasm-perf-genome))
)