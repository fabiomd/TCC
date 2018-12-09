(in-package #:wao)

(defclass webassembly-symbols-table (node)
  ((globals  :initarg :globals  :accessor globals  :initform '())
   (params   :initarg :params   :accessor params   :initform '())
   (locals   :initarg :locals   :accessor locals   :initform '())
   (results  :initarg :results  :accessor results  :initform '())))

(defun get-availables-inputs (table)
	(let ((available-inputs '()))
		(with-slots (globals params locals) table
			(setf available-inputs (append available-inputs globals)
				  available-inputs (append available-inputs params)
				  available-inputs (append available-inputs locals))
			available-inputs
		)
	)
)

(defun get-availables-locals (table)
	(let ((available-inputs '()))
		(with-slots (locals) table
			(setf available-inputs (append available-inputs locals))
			available-inputs
		)
	)
)

(defun get-availables-globals (table)
	(let ((available-inputs '()))
		(with-slots (globals) table
			(setf available-inputs (append available-inputs globals))
			available-inputs
		)
	)
)


(defun get-expected-outputs (table)
	(let ((expected-outputs '()))
		(with-slots (results) table
			results
		)
	)
)

; ****************************************************************************************************

(defun get-type-from-name (name webassembly-symbols-table)
	(let ((available-inputs (get-availables-inputs webassembly-symbols-table)))
		(loop for temp-input in available-inputs do
			(if (eql (slot-value temp-input 'name) name)
				(return (slot-value temp-input 'typesym))
			)
		)
	)
)

; ****************************************************************************************************

(defun get-type-from-symbol (symbol)
	(format-symbol-type (slot-value symbol 'typesym))
)

(defun get-name-from-symbol (symbol)
	(format-symbol-type (slot-value symbol 'name))
)

; ****************************************************************************************************

(defun generate-symbol-name ()
	(write-to-string (generate-symbol))
)

; ****************************************************************************************************

(defun filter-symbols-for-type (symbols typesym)
	(let ((match-symbols '()))
		(loop for symbol in symbols do
			(if (eql (slot-value symbol 'typesym) typesym)
				(setf match-symbols (append match-symbols (list symbol)))
			)
		)
		match-symbols
	)
)

; ****************************************************************************************************

(defun copy-webassembly-symbols-table (table)
	(with-slots (globals params locals results) table
		(make-instance (type-of table)
			:globals (copy-webassembly-symbols globals)
			:params (copy-webassembly-symbols params)
			:locals (copy-webassembly-symbols locals)
			:results (copy-webassembly-symbols results)
		)
	)
)

; ****************************************************************************************************

(defun add-globals (table globals)
	(setf (slot-value table 'globals) (append (slot-value table 'globals) globals))
)

(defun add-locals (table locals)
	(setf (slot-value table 'locals) (append (slot-value table 'locals) locals))
)

(defun add-params (table params)
	(setf (slot-value table 'params) (append (slot-value table 'params) params))
)

(defun set-results (table results)
	(let ((typesym (slot-value results 'typesym)))
		(if (not (find (string-downcase typesym) *void-types* :test #'equal))
			(setf (slot-value table 'results) (list results))
		)
	)
)