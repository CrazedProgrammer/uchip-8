(import err ())
(import lua/math (floor))

(defun resolve-labels (lines-tokens)
  (let* [(labels {})
         (pc 0x200)
         (cut-lines-tokens (traverse lines-tokens (lambda (line-tokens)
              (let* [(first-token (car line-tokens))
                     (line-type (when first-token (car first-token)))]
                (case line-type
                  [opcode (when (/= (cadr first-token) "dd") (inc! pc)) (inc! pc) line-tokens]
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


(defun err-args! (line-idx opcode)
  (err-line! line-idx (.. "invalid types of arguments to opcode \"" opcode "\"")))

(defun assert-args! (line-info param-args-types)
  (when-let* [(args-types (car line-info))
              (opcode (cadr line-info))
              (line-idx (caddr line-info))
              (failed (neq? args-types param-args-types))]
    (err-args! line-idx opcode)))


(defun generate-opcode (line-tokens line-idx)
  (if (empty? line-tokens)
    nil
    (let* [(args-tokens (cdr line-tokens))
           (args (map cadr args-tokens))
           (args-types (map car args-tokens))
           (n-args (# args))
           (opcode (cadar line-tokens))
           (line-info (list args-types opcode line-idx))]
      (case opcode
        ["cls" (assert-args! line-info '()) 0x00E0]
        ["ret" (assert-args! line-info '()) 0x00EE]
        ["sys" (assert-args! line-info '(address)) (car args)]
        ["jp" (if (eq? args-types '(address))
                (+ 0x1000 (car args))
                (progn (assert-args! line-info '(v address))
                       (if (= (car args) 0)
                         (+ 0xB000 (cadr args))
                         (err-line! line-idx "invalid register number to \"jp\""))))]
        ["call" (assert-args! line-info '(address)) (+ 0x2000 (car args))]
        ["se" (if (eq? args-types '(v byte))
                (+ 0x3000 (+ (* 0x100 (car args)) (cadr args)))
                (progn (assert-args! line-info '(v v))
                       (+ 0x5000 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))))]
        ["sne" (if (eq? args-types '(v byte))
                (+ 0x4000 (+ (* 0x100 (car args)) (cadr args)))
                (progn (assert-args! line-info '(v v))
                       (+ 0x9000 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))))]
        ["ld" (case args-types 
                [(v byte) (+ 0x6000 (+ (* 0x100 (car args)) (cadr args)))]
                [(v v) (+ 0x8000 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
                [(i address) (+ 0xA000 (cadr args))]
                [(v dt) (+ 0xF007 (* 0x100 (car args)))]
                [(v k) (+ 0xF00A (* 0x100 (car args)))]
                [(dt v) (+ 0xF015 (* 0x100 (cadr args)))]
                [(st v) (+ 0xF018 (* 0x100 (cadr args)))]
                [(f v) (+ 0xF029 (* 0x100 (cadr args)))]
                [(b v) (+ 0xF033 (* 0x100 (cadr args)))]
                [(ai v) (+ 0xF055 (* 0x100 (cadr args)))]
                [(v ai) (+ 0xF065 (* 0x100 (car args)))]
                [_ (err-args! line-idx opcode)])]
        ["add" (case args-types
                 [(v byte) (+ 0x7000 (+ (* 0x100 (car args)) (cadr args)))]
                 [(v v) (+ 0x8004 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
                 [(i v) (+ 0xF01E (* 0x100 (cadr args)))]
                 [_ (err-args! line-idx opcode)])]
        ["or" (assert-args! line-info '(v v)) (+ 0x8001 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
        ["and" (assert-args! line-info '(v v)) (+ 0x8002 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
        ["xor" (assert-args! line-info '(v v)) (+ 0x8003 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
        ["sub" (assert-args! line-info '(v v)) (+ 0x8005 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
        ["shr" (assert-args! line-info '(v)) (+ 0x8006 (* 0x100 (car args)))]
        ["subn" (assert-args! line-info '(v v)) (+ 0x8007 (+ (* 0x100 (car args)) (* 0x10 (cadr args))))]
        ["shl" (assert-args! line-info '(v)) (+ 0x800E (* 0x100 (car args)))]
        ["rnd" (assert-args! line-info '(v byte)) (+ 0xC000 (+ (* 0x100 (car args)) (cadr args)))]
        ["drw" (assert-args! line-info '(v v byte)) (if (< (caddr args) 0x10)
                                                      (+ 0xD000 (+ (+ (* 0x100 (car args)) (* 0x10 (cadr args))) (caddr args)))
                                                      (err-args! line-idx opcode))]
        ["skp" (assert-args! line-info '(address)) (+ 0xE09E (car args))]
        ["sknp" (assert-args! line-info '(address)) (+ 0xE0A1 (car args))]
        ["dd" (assert-args! line-info '(byte)) (car args)]
        ["dw" (assert-args! line-info '(byte byte)) (+ (* 0x100 (car args)) (cadr args))]
        [_ (err-line! line-idx (.. "unknown opcode \"" opcode "\""))]))))

(defun generate-binary (lines-tokens)
  (with (binary '())
    (for line-idx 1 (# lines-tokens) 1
      (when-let* [(line-tokens (nth lines-tokens line-idx))
                  (opcode (generate-opcode line-tokens line-idx))]
        (when (/= (cadar line-tokens) "dd")
          (push-cdr! binary (floor (/ opcode 256))))
        (push-cdr! binary (% opcode 256))))
    binary))

(defun parse (lines-tokens)
  (let* [(lines-tokens (resolve-labels lines-tokens))
         (binary (generate-binary lines-tokens))]
    (exit-failed!)
    binary))