#lang racket
(require rackunit)
(require rackunit/text-ui)
(require racket/include)
(include "simev.ss")
(assert 1 1)
(define minimal-maze
  '(
    (w   w   w)
      (w   0   w)
    (w   w   w)
    )
  )
 (define minimal-maze_with_space
  '(
    (w   w   w   w   w)
      (w   0   0   w   w)
    (w   0   0   0   w)
      (w   0   0   w   w)
    (w   w   w   w   w)
    )
  )

(define task1_sample01
  '((((w w w w w w) (w 0 w 0 w w) (w 0 w 0 0 w) (w 0 0 0 w w) (w w w w w w)) (1 1) west) start ((procedure start (turn-right (if wall? (turn-left (if wall? (turn-left (if wall? turn-left step)) step)) step) put-mark start)) (procedure turn-right (turn-left turn-left turn-left turn-left turn-left))) 3)
)
(define task1_sample01_res
  '((turn-left turn-left turn-left turn-left turn-left turn-left turn-left step put-mark turn-left turn-left turn-left turn-left turn-left turn-left turn-left step put-mark) (((w w w w w w) (w 0 w 0 w w) (w 1 w 0 0 w) (w 1 0 0 w w) (w w w w w w)) (1 3) southeast))
)
(define task1_sample02
  '((((w w w) (w 0 w) (w 0 w) (w w w)) (1 2) southwest) turn-west ((procedure turn-west (if west? () (turn-left turn-west)))) 4)
)
(define task1_sample02_res
  '((turn-left turn-left turn-left turn-left) (((w w w) (w 0 w) (w 0 w) (w w w)) (1 2) northwest))
)
(define task1_sample03
  '((((w w w) (w 0 w) (w 0 w) (w w w)) (1 2) northeast) (step put-mark put-mark turn-left) () 3)
)
(define task1_sample03_res
  '((step put-mark put-mark turn-left) (((w w w) (w 2 w) (w 0 w) (w w w)) (1 1) northwest))
)
(define task1_sample04
  '((((w w w w w w) (w 0 0 0 0 w) (w w w w w w)) (4 1) west) (add-one add-one add-one add-one add-one) ((procedure add-one (if mark? (get-mark step add-one turn-180 step turn-180) (put-mark))) (procedure turn-180 (turn-left turn-left turn-left))) 30)
)
(define task1_sample04_res
  '((put-mark get-mark step put-mark turn-left turn-left turn-left step turn-left turn-left turn-left put-mark get-mark step get-mark step put-mark turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left step turn-left turn-left turn-left put-mark) (((w w w w w w) (w 0 1 0 1 w) (w w w w w w)) (4 1) west))
)
(define task1_sample05
  '((((w w w) (w 0 w) (w w w)) (1 1) west) step () 1)
)
(define task1_sample05_res
  '(() (((w w w) (w 0 w) (w w w)) (1 1) west))
)
(define task1_sample06
  '((((w w w) (w 0 w) (w 0 w) (w 0 w) (w 0 w) (w 0 w) (w w w)) (1 4) southwest) (go go) ((procedure go (if wall? (turn-left turn-left turn-left) (step go step)))) 2)
)
(define task1_sample06_res
  '((turn-left turn-left turn-left step turn-left turn-left turn-left step) (((w w w) (w 0 w) (w 0 w) (w 0 w) (w 0 w) (w 0 w) (w w w)) (1 4) southwest))
)
(define task1_sample07
  '((((w w w w w w w w w) (w 3 0 w 0 0 0 0 w) (w w 0 w 0 w w 0 w) (w 0 1 0 0 0 0 8 w) (w w 0 0 0 w w 0 w) (w 0 5 0 w 0 1 0 w) (w 4 w 0 w 1 7 0 w) (w w w w w w w w w)) (4 1) west) add-mark-to-maze ((procedure add-mark-to-maze (if mark? (get-mark (if mark? (put-mark) (put-mark put-mark (if wall? () (step add-mark-to-maze step-back)) turn-left (if wall? () (step add-mark-to-maze step-back)) turn-left (if wall? () (step add-mark-to-maze step-back)) turn-left turn-left (if wall? () (step add-mark-to-maze step-back)) turn-left (if wall? () (step add-mark-to-maze step-back)) turn-left get-mark))) (put-mark add-mark-to-maze get-mark))) (procedure step-back (turn-left turn-left turn-left step turn-left turn-left turn-left))) 20)
)
(define task1_sample07_res
  '((put-mark get-mark put-mark put-mark turn-left step put-mark get-mark put-mark put-mark step put-mark get-mark put-mark put-mark step put-mark get-mark put-mark put-mark step get-mark put-mark turn-left turn-left turn-left step turn-left turn-left turn-left turn-left step put-mark get-mark put-mark put-mark turn-left turn-left step put-mark get-mark put-mark put-mark step put-mark get-mark put-mark put-mark turn-left step get-mark put-mark turn-left turn-left turn-left step turn-left turn-left turn-left turn-left step get-mark put-mark turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left step put-mark get-mark put-mark put-mark step put-mark get-mark put-mark put-mark step get-mark put-mark turn-left turn-left turn-left step turn-left turn-left turn-left turn-left step put-mark get-mark put-mark put-mark step) (((w w w w w w w w w) (w 3 0 w 2 0 0 0 w) (w w 0 w 2 w w 2 w) (w 0 1 2 2 2 2 8 w) (w w 0 2 2 w w 0 w) (w 0 5 2 w 0 1 0 w) (w 4 w 0 w 1 7 0 w) (w w w w w w w w w)) (7 1) northeast))
)
(define task1_sample08
  '((((w w w w w w w) (w 0 0 1 1 w w) (w w 0 1 1 0 w) (w w w w w w w)) (4 1) west) add ((procedure add (sub-one turn-180 go turn-right step turn-right turn-right add-one turn-180 go turn-left turn-left step turn-left add)) (procedure add-one (if mark? (get-mark step add-one turn-180 step turn-180) (put-mark))) (procedure sub-one (if mark? (get-mark) (put-mark step sub-one turn-180 step turn-180))) (procedure turn-180 (turn-left turn-left turn-left)) (procedure turn-right (turn-left turn-left turn-left turn-left turn-left)) (procedure go (if wall? () (step go)))) 100)
)
(define task1_sample08_res
  '((get-mark turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left put-mark turn-left turn-left turn-left turn-left turn-left step turn-left put-mark step get-mark turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left get-mark step get-mark step get-mark step put-mark turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left step turn-left get-mark turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left step turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left turn-left put-mark turn-left turn-left turn-left turn-left turn-left step turn-left put-mark step put-mark step put-mark step put-mark) (((w w w w w w w) (w 1 1 1 1 w w) (w w 1 0 0 1 w) (w w w w w w w)) (1 1) west))
)


;first test are based on Jakub Kulhan's code:
;https://gist.github.com/jakubkulhan/9402478

(define maze-tests
  (test-suite
   "maze"
   (test-suite
    "simulate"
    (test-case "empty program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '()
                          '()
                          0)
                `(() (,minimal-maze (1 1) west))
                )
               )
    (test-case "complicated empty program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '(() ((())) (()))
                          '()
                          0)
                `(() (,minimal-maze (1 1) west))
                )
               )
    (test-case "turn left program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '(turn-left)
                          '()
                          0)
                `((turn-left) (,minimal-maze (1 1) southwest))
                )
               )
    (test-case "turn left program (symbol)"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          'turn-left
                          '()
                          0)
                `((turn-left) (,minimal-maze (1 1) southwest))
                )
               )
    (test-case "list program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '(turn-left turn-left turn-left)
                          '()
                          0)
                `((turn-left turn-left turn-left) (,minimal-maze (1 1) east))
                )
               )
    (test-case "put-mark program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '(put-mark put-mark)
                          '()
                          0)
                `((put-mark put-mark) 
                  (,(apply-at-yx (lambda (x) 2) minimal-maze 1 1) (1 1) west))
                )
               )
    ;
    ;removed because simev code has no testing whether it is impossible get mark or not
    ;(test-case "put-mark/get-mark program"
    ;           (check-equal?
    ;            (simulate (list minimal-maze '(1 1) 'west)
    ;                      '(put-mark get-mark get-mark get-mark turn-left)
    ;                      '()
    ;                      0)
    ;            `((put-mark get-mark) (,minimal-maze (1 1) west))
    ;            )
    ;           )
    (test-case "step program"
               (check-equal?
                (simulate (list minimal-maze_with_space '(2 2) 'west)
                          'step
                          '()
                          0)
                `((step) (,minimal-maze_with_space (1 2) west))
                )
               )
    (test-case "if west? program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '(if west? turn-left put-mark)
                          '()
                          0)
                `((turn-left) (,minimal-maze (1 1) southwest))
                )
               )
    (test-case "if mark? program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '(if mark? put-mark turn-left)
                          '()
                          0)
                `((turn-left) (,minimal-maze (1 1) southwest))
                )
               )
    (test-case "if wall? program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          '(if wall? turn-left put-mark)
                          '()
                          0)
                `((turn-left) (,minimal-maze (1 1) southwest))
                )
               )
    (test-case "simple proc program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          'start
                          '((procedure start
                                       (turn-left turn-left turn-left)))  ;change in Jakub's code : added parenthesis arround turn-lefts
                          1)
                `((turn-left turn-left turn-left) (,minimal-maze (1 1) east))
                )
               )
    (test-case "recursive proc program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          'start
                          '((procedure start
                                       (turn-left start)))
                          3)
                `((turn-left turn-left turn-left) (,minimal-maze (1 1) east))
                )
               )
    (test-case "recursive 2 proc program"
               (check-equal?
                (simulate (list minimal-maze '(1 1) 'west)
                          'foo
                          '((procedure foo
                                       (turn-left bar))
                            (procedure bar
                                       (turn-left foo)))
                          3)
                `((turn-left turn-left turn-left) (,minimal-maze (1 1) east))
                )
               )
    
    
    (test-case "task1_sample01"
               (check-equal?
                (apply simulate task1_sample01)
               task1_sample01_res
               )
     )
    (test-case "task1_sample02"
               (check-equal?
                (apply simulate task1_sample02)
               task1_sample02_res
               )
     )
    (test-case "task1_sample03"
               (check-equal?
                (apply simulate task1_sample03)
               task1_sample03_res
               )
     )
    (test-case "task1_sample04"
               (check-equal?
                (apply simulate task1_sample04)
               task1_sample04_res
               )
     )
    (test-case "task1_sample05"
               (check-equal?
                (apply simulate task1_sample05)
               task1_sample05_res
               )
     )
    (test-case "task1_sample06"
               (check-equal?
                (apply simulate task1_sample06)
               task1_sample06_res
               )
     )
    (test-case "task1_sample07"
               (check-equal?
                (apply simulate task1_sample07)
               task1_sample07_res
               )
     )
    (test-case "task1_sample08"
               (check-equal?
                (apply simulate task1_sample08)
               task1_sample08_res
               )
     )
    
    
    )
   )
  )
 
(run-tests maze-tests)