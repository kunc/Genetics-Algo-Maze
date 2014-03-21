;#lang racket
(require racket/trace) ;for debugging
(require rackunit)
(require rackunit/text-ui)
(require racket/include)

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
(define (at list i)
  (cond
    ((null? list) '())
    ((= i 0) (car list))
    (else (at (cdr list) (- i 1)))
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
(define (apply-at function list i)
  (cond
    ((null? list) '())
    ((= i 0) (cons (function (car list)) (cdr list)))
    (else
       (cons (car list) (apply-at function (cdr list) (-- i)))
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
;get-maze
(define (get-maze state)
  (car state)
  )
;(assert maze (get-maze get-initial-state))
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
    ((eqv? 'west      (get-ori state))(list (get-maze state) (get-pos state) 'southwest (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'southwest (get-ori state))(list (get-maze state) (get-pos state) 'southeast (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'southeast (get-ori state))(list (get-maze state) (get-pos state) 'east      (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'east      (get-ori state))(list (get-maze state) (get-pos state) 'northeast (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'northeast (get-ori state))(list (get-maze state) (get-pos state) 'northwest (cons 'turn-left (get-seq state)) (get-cod state)))
    ((eqv? 'northwest (get-ori state))(list (get-maze state) (get-pos state) 'west      (cons 'turn-left (get-seq state)) (get-cod state)))
   )
 )

;put-mark
(define (put-mark state)
  (list 
   (apply-at-yx ++ (get-maze state) (cadr (get-pos state)) (car (get-pos state))) 
   (get-pos state)
   (get-ori state)
   (cons 'put-mark (get-seq state))
   (get-cod state)
  )
 )

;get-mark
(define (get-mark state)
  (list 
   (apply-at-yx -- (get-maze state) (cadr (get-pos state)) (car (get-pos state))) 
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
      ((eqv? 'west o) (list (get-maze state) (apply-at -- p 0) o s c))
      ((eqv? 'east o) (list (get-maze state) (apply-at ++ p 0) o s c))
      ((even? (at p 1))
         (cond
           ((eqv? 'northwest o) (list (get-maze state) (l-- p)           o s c))
           ((eqv? 'northeast o) (list (get-maze state) (apply-at -- p 1) o s c))
           ((eqv? 'southwest o) (list (get-maze state) (l-+ p)           o s c))
           ((eqv? 'southeast o) (list (get-maze state) (apply-at ++ p 1) o s c))
          )
      )
      (else
        (cond
           ((eqv? 'northwest o) (list (get-maze state) (apply-at -- p 1) o s c))
           ((eqv? 'northeast o) (list (get-maze state) (l+- p)           o s c))
           ((eqv? 'southwest o) (list (get-maze state) (apply-at ++ p 1) o s c))
           ((eqv? 'southeast o) (list (get-maze state) (l++ p)           o s c))
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
  (if (< 0 (at-yx (get-maze state) (cadr (get-pos state)) (car (get-pos state)))) #t #f)
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