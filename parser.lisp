(import err ())
(import lua/math (floor))

(defun resolve-labels (lines-tokens)
  (let* [(labels {})
         (pc 0x200)
         (cut-lines-tokens (traverse lines-tokens (lambda (line-tokens)
              (let* [(first-token (car line-tokens))
                     (line-type (car first-token))]
                (case line-type
                  [opcode (inc! pc) (inc! pc) line-tokens]
                  [label (.<! labels (cadr first-token) pc) '()]
                  [_ line-tokens])))))
         (resolved-lines-tokens (traverse (range 1 (# cut-lines-tokens))
            (lambda (line-idx)
              (let* [(line-tokens (get-idx cut-lines-tokens line-idx))]
                (traverse line-tokens (lambda (token)
                    (case (car token)
                      [label (if (.> labels (cadr token))
                        (list 'address (.> labels (cadr token)))
                        (progn (err-line! line-idx (.. "unknown label \"" (cadr token) "\"")) nil))]
                      [_ token])))))))]
    resolved-lines-tokens))

(defun check-args (args-tokens args-types)
  (if (/= (# args-tokens) (# args-types))
    false
    (with (check true)
      (for arg-idx 1 (# args-tokens) 1
        (when (neq? (car (nth args-tokens arg-idx)) (nth args-types arg-idx))
          (set! check false)))
      check)))

(defun err-args! (line-idx opcode)
  (err-line! line-idx (.. "invalid types of arguments to opcode \"" opcode "\"")))

(defun assert-args! (line-info args-types)
  (when-let* [(args-tokens (car line-info))
              (opcode (cadr line-info))
              (line-idx (caddr line-info))
              (failed (! (check-args args-tokens args-types)))]
    (err-args! line-idx opcode)))


(defun generate-opcode (line-tokens line-idx)
  (if (empty? line-tokens)
    nil
    (let* [(args-tokens (cdr line-tokens))
           (args (map cadr args-tokens))
           (n-args (# args))
           (opcode (cadar line-tokens))
           (line-info (list args-tokens opcode line-idx))]
      (case opcode
        ["cls" (assert-args! line-info '()) 0x00E0]
        ["ret" (assert-args! line-info '()) 0x00EE]
        ["sys" (assert-args! line-info '(address)) (car args)]
        ["jp" (if (check-args args-tokens '(address))
                (+ 0x1000 (car args))
                (progn (assert-args! line-info '(v address))
                       (if (= (car args) 0)
                         (+ 0xB000 (cadr args))
                         (err-line! line-idx "invalid register number to \"jp\""))))]
        ["se" (if (check-args args-tokens '(v byte))
                (+ 0x3000 (+ (* 0x100 (car args)) (cadr args)))
                (progn (assert-args! line-info '(v v))
                       (+ 0x5000 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))))]
        ["sne" (if (check-args args-tokens '(v byte))
                (+ 0x4000 (+ (* 0x100 (car args)) (cadr args)))
                (progn (assert-args! line-info '(v v))
                       (+ 0x9000 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))))]
        ["ld" (cond [(check-args args-tokens '(v byte)) (+ 0x6000 (+ (* 0x100 (car args)) (cadr args)))]
                    [(check-args args-tokens '(v v)) (+ 0x8000 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
                    [(check-args args-tokens '(i address)) (+ 0xA000 (cadr args))]
                    [(check-args args-tokens '(v dt)) (+ 0xF007 (* 0x100 (car args)))]
                    [(check-args args-tokens '(v k)) (+ 0xF00A (* 0x100 (car args)))]
                    [(check-args args-tokens '(dt v)) (+ 0xF015 (* 0x100 (cadr args)))]
                    [(check-args args-tokens '(st v)) (+ 0xF018 (* 0x100 (cadr args)))]
                    [(check-args args-tokens '(f v)) (+ 0xF029 (* 0x100 (cadr args)))]
                    [(check-args args-tokens '(b v)) (+ 0xF033 (* 0x100 (cadr args)))]
                    [(check-args args-tokens '(ai v)) (+ 0xF055 (* 0x100 (cadr args)))]
                    [(check-args args-tokens '(v ai)) (+ 0xF065 (* 0x100 (car args)))]
                    [true (err-args! line-idx opcode)])]
        ["call" (assert-args! line-info '(address)) (+ 0x2000 (car args))]
        [_ (err-line! line-idx (.. "unknown opcode \"" opcode "\""))]))))

(defun generate-binary (lines-tokens)
  (with (binary '())
    (for line-idx 1 (# lines-tokens) 1
      (when-let* [(line-tokens (nth lines-tokens line-idx))
                  (opcode (generate-opcode line-tokens line-idx))]
        (push-cdr! binary (floor (/ opcode 256)))
        (push-cdr! binary (% opcode 256))))
    binary))

(defun parse (lines-tokens)
  (let* [(lines-tokens (resolve-labels lines-tokens))
         (binary (generate-binary lines-tokens))]
    (exit-failed!)
    binary))