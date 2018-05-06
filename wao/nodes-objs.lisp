(in-package #:wao)

(defclass node ()
  ((operator    :initarg :operator    :accessor operator    :initform nil)))

; ****************************************************************************************************

(defclass scope-node (node)
  ((name     :initarg :name     :accessor name     :initform nil)))

; ****************************************************************************************************

; (module ...)
; ... represents a list of nodes
(defclass module-node (node)
  ((operator :initarg :operator :accessor operator :initform 'MODULE)
   (body     :initarg :body     :accessor body     :initform nil)))

; (table 0 $1)
(defclass table-node (node)
  ((operator :initarg :operator :accessor operator :initform 'TABLE)
   (name     :initarg :name     :accessor name     :initform nil)
   (typeop   :initarg :typeop   :accessor typeop   :initform nil)))

; (memory $0 1)
(defclass memory-node (node)
  ((operator :initarg :operator :accessor operator :initform 'MEMORY)
   (name     :initarg :name     :accessor name     :initform nil)
   (index    :initarg :index    :accessor index    :initform nil)))
; (export "name" method)
; examples (func $0) (mdoule $0)
(defclass export-node (node)
  ((operator :initarg :operator :accessor operator :initform 'EXPORT)
   (name     :initarg :name     :accessor name     :initform nil)
   (scope    :initarg :scope    :accessor scope    :initform nil)))


; (func "name" signature body )
; body can be almost any node
(defclass func-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'FUNC)
   (name      :initarg :name      :accessor name      :initform nil)
   (signature :initarg :signature :accessor signature :initform nil)
   (body      :initarg :body      :accessor body      :initform nil)))

; ****************************************************************************************************

; examples (param $0 i32) (local $1 i32) (result i32)
(defclass signature-node (node)
  ((typeop   :initarg :typeop   :accessor typeop   :initform nil)
   (operator :initarg :operator :accessor operator :initform nil)))

(defclass param (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'PARAM)
   (name     :initarg :name     :accessor name     :initform nil)))

(defclass local (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'LOCAL)
   (name     :initarg :name     :accessor name     :initform nil)))

(defclass result (signature-node)
  ((operator :initarg :operator :accessor operator :initform 'RESULT)))

; ****************************************************************************************************

; i32.add funcall call ...
(defclass operator-node (node)
  ((typeop     :initarg :typeop     :accessor typeop     :initform nil)
   (parameters :initarg :parameters :accessor parameters :initform nil)))

; ****************************************************************************************************

(defclass get-local-node (node)
  ((operator  :initarg :operator  :accessor operator  :initform 'GET_LOCAL)
   (name      :initarg :name      :accessor name      :initform nil)))

; ****************************************************************************************************