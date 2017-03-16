(import extra/term (colored))

(define failed `[false])

(defun err! (message)
  (print! (colored 31 (.. "[ERROR] " message)))
  (set-idx! failed 1 true))

(defun err-line! (line message)
  (err! (.. "line " (number->string line) ": " message)))

(defun exit-failed! ()
	(when (= (nth failed 1) true)
		(exit! "compilation failed." -1)))