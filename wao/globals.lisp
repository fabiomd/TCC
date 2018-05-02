(in-package #:wao)

; SOFTWARE-EVOLUTION-ADAPTER VARIABLES
(defvar *population*               nil "a list of the software objects currently known to the system. This variable may be read to inspect a running search process, or written to as part of a running search process")
(defvar *max-population-size*      nil "maximum allowable population size")
; (defvar *tournament-size*          nil "number of elements in tournament")
; (defvar *tournament-eviction-size* nil "number of individuals to participate in eviction tournaments")
(defvar *fitness-predicate*        nil "function to compare two fitness values to select which is preferred")
; (defvar *cross-chance*             nil "fraction of new individuals generated using crossover rather than mutation")
; (defvar *mut-rate*                 nil "chance to mutate a new individual")
; (defvar *fitness-evals*            nil "this variable tracks the total number of fitness evaluations performed")
; (defvar *running*                  nil "true when a search process is running, set this variable to nil to stop a running search")

; ADAPTER VARIABLES
(defvar *original-file-path*       nil "path to original file")
(defvar *original*                 nil "original software")
(defvar *fitness-shell-path*       nil "path to fitness shell")
(defvar *evals*                    nil "maximum number of test evaluations.")
(defvar *period*                   nil "period at which to run `checkpoint'.")
(defvar *actions*                  nil "list of action the system can choose")

; UTILS VARIABLES
(defvar *current-step*             0   "current step")