(in-package #:wao)

(defclass webassembly-symbol ()
  ((name     :initarg :name      :accessor name      :initform nil)
   (typesym  :initarg :typesym   :accessor typesym   :initform nil)))

(defclass webassembly-result-symbol ()
  ((typesym  :initarg :typesym   :accessor typesym   :initform nil)))

(defclass webassembly-function ()
  ((name        :initarg :name         :accessor name         :initform nil)
   (parameters  :initarg :parameters   :accessor parameters   :initform nil)
   (resulttype  :initarg :resulttype   :accessor resulttype   :initform nil)))

; ****************************************************************************************************

(defun copy-webassembly-symbols (symbols)
	(let ((temp-symbols '()))
		(loop for symbol in symbols do
			(if (eql (type-of symbol) 'webassembly-symbol)
				(setf temp-symbols (append temp-symbols (list (copy-webassembly-symbol symbol))))
			)
			(if (eql (type-of symbol) 'webassembly-result-symbol)
				(setf temp-symbols (append temp-symbols (list (copy-webassembly-result-symbol symbol))))
			)
		)
		temp-symbols
	)
)

(defun copy-webassembly-symbol (symbol)
	(with-slots (name typesym) symbol
		(make-instance 'webassembly-symbol
			:name name
			:typesym typesym 
		)
	)
)

(defun copy-webassembly-result-symbol (symbol)
	(make-instance 'webassembly-symbol
		:typesym (slot-value symbol 'typesym) 
	)
)

; ****************************************************************************************************

(defun create-symbols (nodes)
	(let ((symbols '()))
		(loop for node in nodes do
			(cond ((eql (type-of node) 'param)
				(setf symbols (append symbols (list (create-symbol-from-param node)))))
				  ((eql (type-of node) 'result)
				(setf symbols (append symbols (list (create-symbol-from-result node)))))
				  ((eql (type-of node) 'set-local-node)
				(setf symbols (append symbols (list (create-symbol-from-local node)))))
			)
		)
		symbols
	)
)

(defun create-symbol-from-param (node)
	(with-slots (name typeop) node
		(make-instance 'webassembly-symbol
			:name name
			:typesym typeop
		)
	)
)

(defun create-symbol-from-result (node)
	(with-slots (typeop) node
		(make-instance 'webassembly-result-symbol
			:typesym typeop
		)
	)
)

(defun create-symbol-from-local (node)
	(with-slots (name typeop) node
		(make-instance 'webassembly-symbol
			:name name
			:typesym typeop
		)
	)
)

(defun create-result-symbol-from-type (typeop)
	(make-instance 'webassembly-result-symbol
		:typesym typeop
	)
)

(defun is-symbol (node)
	(cond ((eql (type-of node) 'webassembly-symbol)
		T)
		((eql (type-of node) 'webassembly-result-symbol)
			T)
		(T nil)
	)
)