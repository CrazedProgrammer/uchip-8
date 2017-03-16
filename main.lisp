(import extra/io (read-lines! write-bytes!))
(import string)
(import lexer (lex))
(import parser (parse))
(import err ())

(defun load-input! (infile)
  (with (lines (read-lines! infile))
    (when (! lines)
      (err! "failed to read input file."))
    (exit-failed!)
    lines))

(defun write-output! (outfile data)
  (when (! (write-bytes! outfile data))
    (err! "failed to write to output file."))
  (exit-failed!))

(defun compile (infile outfile)
    (let* [(lines (load-input! infile))
           (lexed-lines (lex lines))
           (output (parse lexed-lines))]
      (print! (pretty output))))



(defun run ()
  (if (= (# arg) 0)
    (print! "uchip-8 <input file> [output file]")
    (compile (nth arg 1) (or (nth arg 2) "out.ch8"))))

(run)