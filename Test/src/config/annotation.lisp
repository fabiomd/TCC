(in-package :goa)

(defmethod pick-bad ((asm simple)) (pick asm [{+ 0.01} {aget :annotation}]))
(defmethod pick-bad ((asm ann-range))
  (proportional-pick (annotations asm) #'identity))

(defvar *mutation-hooks* nil)

(defgeneric smooth-annotation (asm op)
  (:documentation "Smooth the annotations around a new mutation;"))

(defmethod smooth-annotation ((asm asm) op)
  (with-slots (genome) asm
	      (flet ((blend (i)
			    (setf (cdr (assoc :annotation (nth i genome)))
				  (mean (remove nil
						(list (when (> i 0)
							(aget :annotation (nth (1 - i) genome)))
						      (aget :annotation (nth i genome))))))))
		    (case (car op)
			  (:insert (blend (second op)))
			  (:swap (blend (second op)) (blend (third op)))))))

(defmethod smooth-annotation ((asm ann-range) op)
  (let ((op (first op))
	(sl (second op)))
    (with-slots (anns) asm
		(setf anns
		      (case op
			    (:cut (software-evolution::range-cut anns s1))
			    (:insert (software-evolution::range-insert
				      anns s1 (software-evolution::range-nth s1 anns)))
			    (:swap anns))))))

(defmethod apply-mutation :around ((asm asm) op)
  (call-next-method)
  (smooth-annotation asm op)
  (mapc {funcall _ asm op} *mutation-hooks*)
  asm)
