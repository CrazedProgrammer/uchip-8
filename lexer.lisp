(import string)
(import err ())

(defun remove-comments (line)
  (if (string/find line ";")
    (remove-comments (string/sub line 1 (- (string/find line ";") 1)))
    line))

(defun get-line-parts (line)
  (with (line (string/lower (string/trim (remove-comments line))))
    (if (eq? line "")
      `()
      (let* [(cmd (if (string/find line "%s")
                    (string/sub line 1 (- (string/find line "%s") 1))
                    line))
             (args (if (string/find line "%s")
                     (map string/trim (string/split (string/sub line (+ (string/find line "%s") 1) (#s line)) ","))
                     `()))]
        (cons cmd args)))))

(defun letters-only (str)
  (with (match true)
    (for-each idx (range 1 (#s str))
      (with (c (string/byte (string/char-at str idx)))
        (when (or (< c 97) (> c 122))
          (set! match false))))
    match))

(defun valid-label (str)
  (with (match true)
    (for-each idx (range 1 (#s str))
      (when-with (c (string/byte (string/char-at str idx)))
        (if (= idx 1)
          (when (and (or (< c 97) (> c 122)) (/= c 95))
            (set! match false))
          (when (and (or (< c 97) (> c 122)) (or (< c 48) (> c 57)) (/= c 95))
            (set! match false)))))
    match))

(defun parse-int (str)
  (if (= (string/char-at str (#s str)) "h")
    (string->number (string/sub str 1 (- (#s str) 1)) 16)
    (string->number str 10)))

(defun parse-byte (str)
  (when-with (int (parse-int str))
    (when (and (>= int 0) (< int 256))
      int)))

(defun parse-address (str)
  (when (= (string/char-at str 1) "$")
    (when-with (int (parse-int (string/sub str 2 (#s str))))
      (when (and (>= int 0) (< int 4096))
        int))))

(defun parse-register (str)
  (cond 
    [(and (= (string/char-at str 1) "v") (= (#s str) 2))
      (when-with (n (string->number (string/char-at str 2) 16))
        (list 'v n))]
    [(= str "i") (list 'i)]
    [(= str "st") (list 'st)]
    [(= str "dt") (list 'dt)]
    [true nil]))

(defun parse-special (str)
  (cond
    [(= str "k") (list 'k)]
    [(= str "f") (list 'f)]
    [(= str "b") (list 'b)]
    [(= str "[i]") (list 'ai)]
    [true nil]))

(defun parse-token (str)
  (cond 
    [(parse-register str) (parse-register str)]
    [(parse-special str) (parse-special str)]
    [(parse-address str) (list 'address (parse-address str))]
    [(parse-byte str) (list 'byte (parse-byte str))]
    [(valid-label str) (list 'label str)]
    [true '()]))

(defun make-tokens (lines-parts)
  (map (lambda (line-idx)
         (with (parts (nth lines-parts line-idx))
           (if (> (# parts) 0)
             (map (lambda (part-idx)
               (with (part (nth parts part-idx))
                 (if (= part-idx 1)
                   (if (= (string/char-at part -1) ":")
                     (with (label (string/sub part 1 (- (#s part) 1)))
                       (when (! (valid-label label))
                         (err-line! line-idx (.. "invalid label name \"" label "\".")))
                       (list 'label (string/sub part 1 (- (#s part) 1))))
                     (progn
                       (when (! (letters-only part))
                         (err-line! line-idx (.. "unexpected symbol in opcode \"" part "\".")))
                       (list 'opcode part)))
                   (progn
                     (when (= part "")
                       (err-line! line-idx "empty argument."))
                     (with (token (parse-token part))
                       (when (= (# token) 0)
                         (err-line! line-idx (.. "invalid argument \"" part "\".")))
                       token)))))
             (range 1 (# parts)))
             '())))
       (range 1 (# lines-parts))))


(defun lex (lines)
	(let* [(lines-parts (map get-line-parts lines))
         (tokens (make-tokens lines-parts))]
    (exit-failed!)
    tokens))