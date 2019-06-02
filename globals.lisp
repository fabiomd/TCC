(in-package #:wao)

; SOFTWARE-EVOLUTION-ADAPTER VARIABLES
(defvar *population*               nil "a list of the software objects currently known to the system. This variable may be read to inspect a running search process, or written to as part of a running search process")
(defvar *max-population-size*      nil "maximum allowable population size")
; (defvar *tournament-size*          nil "number of elements in tournament")
; (defvar *tournament-eviction-size* nil "number of individuals to participate in eviction tournaments")
(defvar *fitness-predicate*        nil "function to compare two fitness values to select which is preferred")
; (defvar *cross-chance*           nil "fraction of new individuals generated using crossover rather than mutation")
; (defvar *mut-rate*               nil "chance to mutate a new individual")
; (defvar *fitness-evals*          nil "this variable tracks the total number of fitness evaluations performed")
; (defvar *running*                nil "true when a search process is running, set this variable to nil to stop a running search")

; ADAPTER VARIABLES
(defvar *original-file-path*      nil "path to original file")
(defvar *original*                nil "original software")
(defvar *original-body-size*      nil "size of original function bodys")
(defvar *function-symbols*        '() "functions symbols table")
(defvar *fitness-js-path*         nil "fitness node javascript path")
(defvar *fitness-shell-path*      nil "path to fitness shell script")
(defvar *wat-to-wasm-shell-path*  nil "path to wat compiler shell script")
(defvar *evals*                   nil "maximum number of test evaluations.")
(defvar *period*                  nil "period at which to run `checkpoint'.")
(defvar *actions*                 nil "list of action the system can choose")

; UTILS VARIABLES
(defvar *current-step*            0   "current step")

; *******************************************************************************************
(defvar *void-types*              (list "") "webassembly void representation")
(defvar *void-operators*          (list "set_local local") "webassembly void operators")
(defvar *dynamic-operators*       (list "call") "webassembly dynamic type operators")
(defvar *i-value-types*           (list "i32" "i64") "webassembly value int types")
(defvar *f-value-types*           (list "f32" "f64") "webassembly value float types")
(defvar *i-32-operators*          (list "add" "sub" "mul" "div_s" "div_u" "rem_s" "rem_u" "and" "or" "xor" "shl" "shr_u" "shr_s" "rotl" "rotr" "eq" "ne" "lt_s" "le_s" "lt_u" "le_u" "gt_s" "ge_s" "gt_u" "ge_u" "clz" "clz" "clz" "ctz" "popcnt" "eqz") "webassembly int 32 operators")
(defvar *i-64-operators*          (list "add" "sub" "mul" "div_s" "div_u" "rem_s" "rem_u" "and" "or" "xor" "shl" "shr_u" "shr_s" "rotl" "rotr" "eq" "ne" "lt_s" "le_s" "lt_u" "le_u" "gt_s" "ge_s" "gt_u" "ge_u" "clz" "clz" "clz" "ctz" "popcnt" "eqz") "webassembly int 64 operators")
(defvar *f-32-operators*          (list "add" "sub" "mul" "div" "abs" "neg" "copysign" "ceil" "floor" "trunc" "nearest" "eq" "ne" "lt" "le" "gt" "ge" "sqrt" "min" "max") "webassembly float 32 operators")
(defvar *f-64-operators*          (list "add" "sub" "mul" "div" "abs" "neg" "copysign" "ceil" "floor" "trunc" "nearest" "eq" "ne" "lt" "le" "gt" "ge" "sqrt" "min" "max") "webassembly float 64 operators")
(defvar *trunc-operators*         (list "trunc_s" "trunc_u")   "webassembly trunc type")
(defvar *extend-operators*        (list "extend_s" "extend_u") "webassembly extend type")
(defvar *convert-operators*       (list "convert_u" "convert_s")   "webassembly convert type")

; *******************************************************************************************

(defvar *watcode-path*            "./temp/watcode/" "path to temp .wat file")
(defvar *wasmcode-path*           "./temp/wasmcode/" "path to temp .wasm file")
(defvar *wat-extension*           ".wat"          "wat code extension")
(defvar *wasm-extension*          ".wasm"         "wasm code extension")