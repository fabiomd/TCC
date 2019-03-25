(in-package #:wao)

(defun adapt-node (node expected-type webassembly-symbol-table)
	(let ((node-type (get-node-return-type node webassembly-symbol-table)))
		(if (or (eql node-type expected-type) (find (string-downcase node-type) *void-types* :test #'equal))
			node
			(let ((adapted-node-table (copy-webassembly-symbols-table webassembly-symbol-table)))
				(set-results adapted-node-table (create-result-symbol-from-type (get-node-return-type node adapted-node-table)))
				(let ((adapted-node (generate-convert webassembly-symbol-table node)))
					adapted-node
				)
			)
		)
	)
)