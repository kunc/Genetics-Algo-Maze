;README:
;This code is not ready to hand in because the name of function collide with those in the upload system
;it is function version of Task 1.

;#################################
;     BASIC FUNCTION DEFINITIONS
;#################################

(define (assert a b)
  (cond
    ((equal? a b) #t)
    (else #f)
  )
)

;at - returns the ith element of a list
(define (at lst i)
  (cond
    ((null? lst) '())
    ((= i 0) (car lst))
    (else (at (cdr lst) (- i 1)))
   )
)
;(assert 5 (at '(0 1 2 3 4 5 6 7 8 9) 5))

;at-yx - the xth element in the yth list
(define (at-yx list-of-lists y x)
  (at (at list-of-lists y) x)
 )
;(assert 4 (at-yx '((1 2 3)(4 5 6)(7 8 9)) 1 0))

;at-wyx - the x th element of y th sublist of w th list in the super list
(define (at-wyx LoLoL w y x)
  (at (at (at LoLoL w) y) x)
 )
;(assert 7 (at-wyx '(((1)(2))((3)(4))((5 6)(7 8))) 2 1 0))

;increment
(define (++ i)
  (+ i 1)
 )
;(assert 4 (++ 3))

;decrement
(define (-- i)
  (- i 1)
 )
;(assert 4 (-- 5))

;list increment
(define (l++ list)
  (map ++ list)
 )
;(assert '(2 3) (l++ '(1 2)))
;list decrement
(define (l-- list)
  (map -- list)
 )
;(assert '(1 2) (l-- '(2 3)))

;two elemnt list +-
(define (l+- lst)
  (list (++ (car lst)) (-- (cadr lst)))
 )
;(assert '(1 1) (l+- '(0 2)))

;two elemnt list-+
(define (l-+ lst)
  (list (-- (car lst)) (++ (cadr lst)))
 )
;(assert '(1 1) (l-+ '(2 0)))
;apply-at
(define (apply-at function lst i)
  (cond
    ((null? lst) '())
    ((= i 0) (cons (function (car lst)) (cdr lst)))
    (else
       (cons (car lst) (apply-at function (cdr lst) (-- i)))
     )
   )
 )
;(assert '(0 1 2 3 4 6 6 7 8) (apply-at ++ '(0 1 2 3 4 5 6 7 8) 5))

;apply-at-yx
(define (apply-at-yx function LoL y x)
  (apply-at (lambda (line) (apply-at function line x)) LoL y)
)

;apply-at-wyx
(define (apply-at-wyx function LoLoL w y x)
  (apply-at (lambda (LoL)
              (apply-at (lambda (line)
                          (apply-at function line x)
                         ) LoL y)
              ) LoLoL w)
 )
;(assert  '((0)((1)(2))((3 4) (6 (6)) ((7 8)))) (apply-at-wyx ++ '((0)((1)(2))((3 4) (5 (6)) ((7 8)))) 2 1 0))

;general filter
(define (my-filter predikat lst)
  (cond
    ((null? lst) '())
    ((predikat (car lst)) (cons (car lst) (my-filter predikat (cdr lst))))
    (else (my-filter predikat (cdr lst)))
   )
 )


;###############################
; MAZE Constants
;###############################
(define get-initial-state
  '( ;maze
    ((w   w   w   w   w   w)
       (w   0   w   0   w   w)
     (w   0   w   0   0   w)
       (w   0   0   0   w   w)
     (w   w   w   w   w   w))
    ; startpoint
     (1 1)
     ; orientation
     west
     ;action-list
     (first)
     ;fail code
     0
     )
  )
(define get-test-state
  '( ;maze
    ((w   w   w   w   w   w)
       (w   0   w   0   w   w)
     (w   0   w   0   0   w)
       (w   0   0   0   w   w)
     (w   w   w   w   w   w))
    ; startpoint
     (1 1)
     ; orientation
     west
     ;action-list
     (first)
     ;fail code
     0
     )
  )
(define if1
  '(if wall?
           ( turn-left
             (if wall?
                 (turn-left
                     (if wall?
                        turn-left
                        step
                     )
                 )
                 step
              )
           )
           step  
        )
 )

(define right-hand-rule-prg2
  '(
    (procedure start
      ( turn-right
        (if wall?
           ( turn-left
             (if wall?
                 (turn-left
                     (if wall?
                        turn-left
                        step
                     )
                 )
                 step
              )
           )
           step  
        )
        put-mark
        start
      )
    )   
    (procedure turn-right (turn-left turn-left turn-left turn-left turn-left))
  )
)
(define maze
  '((w   w   w   w   w   w)
       (w   0   w   0   w   w)
     (w   0   w   0   0   w)
       (w   0   0   0   w   w)
     (w   w   w   w   w   w))
 )
(define test-result2
  '(
 (turn-left turn-left turn-left turn-left turn-left turn-left turn-left 
  step put-mark 
  turn-left turn-left turn-left turn-left turn-left turn-left turn-left
  step put-mark)
 (((w   w   w   w   w   w) 
     (w   0   w   0   w   w) 
   (w   1   w   0   0   w) 
     (w   1   0   0   w   w) 
   (w   w   w   w   w   w)) 
 (1 3) southeast))
)
  
;#############################
;Functions
;#############################
;getters
;get-maz
(define (get-maz state)
  (car state)
  )
;(assert maze (get-maz get-initial-state))
;get-pos
(define (get-pos state)
  (cadr state)
 )
;(assert '(1 1) (get-pos get-initial-state))
;get-orientation
(define (get-ori state)
  (caddr state)
)
;(assert 'west (get-ori get-initial-state))
;get-seq
(define (get-seq state)
  (cadddr state)
 )
;(assert '(first) (get-seq get-initial-state));


;get-code
(define (get-cod state)
  (at state 4)
)
;##################
;commands - return state
(define (turn-left state)
  (cond
    ((eqv? 'west      (get-ori state))(list (get-maz state) (get-pos state) 'southwest (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'southwest (get-ori state))(list (get-maz state) (get-pos state) 'southeast (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'southeast (get-ori state))(list (get-maz state) (get-pos state) 'east      (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'east      (get-ori state))(list (get-maz state) (get-pos state) 'northeast (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'northeast (get-ori state))(list (get-maz state) (get-pos state) 'northwest (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'northwest (get-ori state))(list (get-maz state) (get-pos state) 'west      (cons 'turn-left (get-seq state)) (get-cod state)))
   )
 )

;put-mark
(define (put-mark state)
  (list 
   (apply-at-yx ++ (get-maz state) (cadr (get-pos state)) (car (get-pos state))) 
   (get-pos state)
   (get-ori state)
   (cons 'put-mark (get-seq state))
   (get-cod state)
  )
 )

;get-mark
(define (get-mark state)
  (list 
   (apply-at-yx -- (get-maz state) (cadr (get-pos state)) (car (get-pos state))) 
   (get-pos state)
   (get-ori state)
   (cons 'get-mark (get-seq state))
   (get-cod state)
  )
 )

;step
(define (step state)
  (let ((o (get-ori state)) (s (cons 'step (get-seq state)))(p (get-pos state)) (c (get-cod state)))
    (cond
      ((eqv? 'west o) (list (get-maz state) (apply-at -- p 0) o s c))
      ((eqv? 'east o) (list (get-maz state) (apply-at ++ p 0) o s c))
      ((even? (at p 1))
         (cond
           ((eqv? 'northwest o) (list (get-maz state) (l-- p)           o s c))
           ((eqv? 'northeast o) (list (get-maz state) (apply-at -- p 1) o s c))
           ((eqv? 'southwest o) (list (get-maz state) (l-+ p)           o s c))
           ((eqv? 'southeast o) (list (get-maz state) (apply-at ++ p 1) o s c))
          )
      )
      (else
        (cond
           ((eqv? 'northwest o) (list (get-maz state) (apply-at -- p 1) o s c))
           ((eqv? 'northeast o) (list (get-maz state) (l+- p)           o s c))
           ((eqv? 'southwest o) (list (get-maz state) (apply-at ++ p 1) o s c))
           ((eqv? 'southeast o) (list (get-maz state) (l++ p)           o s c))
          )
        )
     )
   )
 )


;conditions -return true or false
;WALL?
(define (if-wall state)
  (let ((p (get-pos (step state))))
    (cond
      ((eqv? 'w (at-wyx state 0 (cadr p) (car p))) #t)
      (else #f)
     )
   )
)

;MARK?
(define (if-mark state)
  (if (< 0 (at-yx (get-maz state) (cadr (get-pos state)) (car (get-pos state)))) #t #f)
 )

;WEST?
(define (if-west state)
  (if (eqv? 'west (get-ori state)) #t #f)
 )

;##############################
;parsing
;get-procedure searchs for a procedure named 'name' in the program
(define (get-procedure name program)
  
  (cond
    ((eqv? name (cadar program))(caddar program))
    (else (get-procedure name (cdr program)))
   )
)

(define (get-if expr state)
  (cond
    ((eqv? 'mark? (at expr 1))
     (if (if-mark state) (at expr 2) (at expr 3))
    )
    ((eqv? 'wall? (at expr 1))
     (if (if-wall state) (at expr 2) (at expr 3))
    )
    ((eqv? 'west? (at expr 1))
     (if (if-west state) (at expr 2) (at expr 3))
    )
   )
 )
;the main function that parses the expressions and calls other functions
(define (main state expr program limit)
  (cond
    ;nothing to do
    ((null? expr) state)
    ;failed?
    ((<= 1 (at state 4)) state)
    ;limit overdrawn, do nothing (and maybe raise an error)
    ((< limit 0) (apply-at ++ state 4))
    
    
    ;if it is list - it may an if branch or another list of instuctions
    ((list? expr)
       (cond
         ((eqv? 'if (car expr)) (main state (get-if expr state) program limit))
         (else (main (main state (car expr) program limit) (cdr expr) program limit))
        )
     )
    ;get-mark
    ((eqv? 'get-mark expr) 
     (if (if-mark state) (get-mark state) state))
    ;put-mark
    ((eqv? 'put-mark expr) (put-mark state))
    ;step -
    ((eqv? 'step expr)
     (cond
       ((if-wall state) (apply-at ++ state 4)) ;if wrong step, raise fail state
       (else (step state))
     ))
    ;turn-left
    ((eqv? 'turn-left expr) (turn-left state))
    ;nothing from above? - it is a procedure, find it and do it
    (else (main state (get-procedure expr program) program (-- limit)))
  )
)
(define (simulate state expr program limit)
(let ((result (main (list (car state) (cadr state) (caddr state) '(first) 0) expr program limit)))
         (list (cdr (reverse (at result 3))) (list (car result) (cadr result) (caddr result)))
 )
  
 ); close the whole simulate function
;(simulate (list maze (list 1 1) 'west) 'start right-hand-rule-prg2 3)


;;quicksort
(define (rozdel comparator pivot s)
  (if (null? s) '(() . ()) ;;. cons - seznam + zbytek
  (let* ( ;;else
          (v (rozdel comparator pivot (cdr s)))
          (a (car v)) ;;mensi nez pivot
          (b (cdr v)) ;;vetsi nez pivot
          (p (car s))) ;;prvni cislo v puvodnim seznamu - to se nedostalo dal do rekurze
    (if (comparator p pivot) ;; p comparator pivot
        (cons (cons p a) b) ;; "mensi" pripoji se pred
        (cons a (cons p b))))))

(define (qsort comparator s)
  (cond 
    ((null? s) s)
    ((null? (cdr s)) s)
    (else (let* (
                  (pivot (car s)) ;;prvni prvek na pivot
                  (r (rozdel comparator pivot (cdr s))) ;;zbytek rozdelit
                  (a (car r)) ;;prvni seznam z rozdeleni
                  (b (cdr r)) ;;druhy seznam z rozdeleni
                  (sa (qsort comparator a))
                  (sb (qsort comparator b))
                  )
            (append sa (cons pivot sb))))))

; lstA < lstB --> True
(define (comp_list lstA lstB)
  (cond
    ((or (null? lstA) (null? lstB)) #f)
    ((> (car lstA) (car lstB)) #f)
    ((< (car lstA) (car lstB)) #t)
    (else (comp_list (cdr lstA) (cdr lstB)))
  )
)

;manhattan distance of two maze
(define (manhattan-dist mazeA mazeB)
  (cond
    ((or (null? mazeA) (null? mazeB)) 0)
    ((and (number? (car mazeA)) (number? (car mazeB)))
       (+ (abs (- (car mazeA) (car mazeB))) (manhattan-dist (cdr mazeA) (cdr mazeB)))
    )
    ((and (list? (car mazeA)) (list? (car mazeB)))
     (+ (manhattan-dist (car mazeA) (car mazeB)) (manhattan-dist (cdr mazeA) (cdr mazeB)))
    )
    (else (manhattan-dist (cdr mazeA) (cdr mazeB)))
  )
)

;configuration distance
(define (config-dist confA confB)
  (if (equal? (caddr confA) (caddr confB)) 
      (+ 
       (abs (- (caadr confA) (caadr confB)))
       (abs (- (cadadr confA) (cadadr confB)))
      )
      (+ 
       1
       (abs (- (caadr confA) (caadr confB)))
       (abs (- (cadadr confA) (cadadr confB)))
      )
    )
 )

;program lenght
(define (prlen prog)
  (cond
    ((null? prog) 0)
    ((list? (car prog)) (+ (prlen (car prog)) (prlen (cdr prog))))
    ((or (equal? 'if (car prog)) (equal? 'procedure (car prog))) (prlen (cdr prog)))
    (else (++ (prlen (cdr prog))))
   )
)

;number of steps - count number of elements in list
(define (count_ele lst)
  (if (null? lst) 0 (++ (count_ele (cdr lst))))
)

;;helper function to summing up (x1,x2,x3,x4) + (y1,y2,y3,y4)= (x1+y1, x2+y2, x3, x4 + y3)
(define (add-result cumulative_res new_res)
  (list (+ (car cumulative_res) (car new_res))
        (+ (cadr cumulative_res) (cadr new_res))
        (caddr cumulative_res)
        (+ (cadddr cumulative_res) (cadddr new_res))
   )
)
(define (evaluate_sim sim_res desired_state)
    (list (manhattan-dist (caadr sim_res) (car desired_state))
          (config-dist (cadr sim_res) desired_state)
          0
          (count_ele (car sim_res))
    )
)
;always count everything eventhough it is clear it will be over the treshold
;(define (evaluate_runned_prog prog pairs treshold stack_size)
;  (if (null? pairs) '(0 0 0 0)
;      (add-result (evaluate_sim 
;                      (simulate (caar pairs) 'start prog stack_size)
;                      (cadar pairs)
;                   )
;                  (evaluate_runned_prog prog (cdr pairs)  treshold stack_size)
;      )
;   )
;)

(define (evaluate_runned_prog_acc prog pairs treshold stack_size exit accu)
  (cond
    ((filter-over-treshold accu treshold) (exit '(-1 -1 -1 -1)))
    ((null? pairs) accu)
    (else (evaluate_runned_prog_acc prog 
                          (cdr pairs)
                          treshold 
                          stack_size 
                          exit 
                          (add-result 
                                     accu
                                     (evaluate_sim 
                                                  (simulate (caar pairs) 'start prog stack_size)
                                                  (cadar pairs)
                                      )    
                           )
          )
    )
  )
)
(define (evaluate_runned_prog prog pairs treshold stack_size)
  (call-with-current-continuation
   (lambda(exit) (evaluate_runned_prog_acc prog pairs treshold stack_size exit '(0 0 0 0)))
  )
)

(define (evaluate_prog prog pairs treshold stack_size)
  (list
   (add-result (list 0 0 (prlen prog) 0) (evaluate_runned_prog prog pairs treshold stack_size))
   prog
  )
)

(define (evaluate_multiple_progs prgs pairs treshold stack_size)
  (cond
    ((null? prgs) '())
    (else
     (cons (evaluate_prog (car prgs) pairs treshold stack_size) (evaluate_multiple_progs (cdr prgs) pairs treshold stack_size))
    )
   )
 )
;returns #t for values over treshold
(define (filter-over-treshold value treshold)
  (cond
    ((> (car value) (car treshold)) #t)
    ((> (cadr value) (cadr treshold)) #t)
    ((> (caddr value) (caddr treshold)) #t)
    ((> (cadddr value) (cadddr treshold)) #t)
    (else #f)
   )
)

;post evaluation filtering - will be replaced by in time filtering
;return #t for good results
(define (filter-bad-predicate result treshold)
  ;(>= (caar result) 0) detects error type result - ie. those over treshold
  (and (not (filter-over-treshold (car result) treshold)) (>= (caar result) 0))
)

;removes all bad results (those over treshold or error type result - negative number)
(define (filter-bad results treshold)
  (display results)
  (my-filter (lambda(x) (filter-bad-predicate x treshold)) results)
 )
(define (compare-by-value resA resB)
  (comp_list (car resA) (car resB))
 )

(define (evaluate prgs pairs treshold stack_size)
  (qsort compare-by-value (filter-bad (evaluate_multiple_progs prgs pairs treshold stack_size) treshold))
)




(define prgs
'(
   ( 
      (procedure start
         (turn-right (if wall? (turn-left 
             (if wall? (turn-left (if wall? turn-left step)) step)) step)
                 put-mark start )
      )   
      (procedure turn-right (turn-left turn-left turn-left turn-left turn-left))
  )
  (
      (procedure start  (put-mark (if wall? turn-left step) start))
  )
  (
      (procedure start (step step step put-mark))
  )
)
)


(define pairs
'(
  (
   (((w w w w w w) 
      (w 0 w 0 w w) 
     (w 1 w 0 0 w) 
      (w 1 0 0 w w) 
     (w w w w w w)) 
     (1 3) southwest)

   (((w w w w w w) 
      (w 0 w 0 w w) 
     (w 0 w 0 0 w) 
      (w 0 0 0 w w) 
     (w w w w w w)) 
     (1 1) northeast)
   )
   (
   (((w w w w w w) 
      (w 0 w 0 w w) 
     (w 0 w 2 0 w) 
      (w 1 3 0 w w) 
     (w w w w w w)) 
     (3 3) northwest)

   (((w w w w w w) 
      (w 0 w 0 w w) 
     (w 0 w 0 0 w) 
      (w 0 0 0 w w) 
     (w w w w w w)) 
     (1 1) northeast)
  ))
 )