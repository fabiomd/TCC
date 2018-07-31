(in-package #:wao)

(defun adapt-node (node expected-type webassembly-symbol-table)
	(let ((node-type (get-node-return-type node webassembly-symbol-table)))
		(if (eql node-type expected-type)
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