(defun resolve-labels (lines-tokens)
  (let* [(labels '())
         (pc 0x200)]
    (for-each line-tokens lines-tokens
      (let* [(first-token (car line-tokens))
             (line-type (car first-token))]
        (case line-type
          [opcode (inc! pc) (inc! pc)]
          [label (push-cdr! labels (list (cadr first-token) pc))]
          [_ nil])))
    labels))

(defun parse (lines-tokens)
  (with (lines-tokens (resolve-labels lines-tokens))
    lines-tokens))