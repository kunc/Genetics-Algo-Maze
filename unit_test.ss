#lang racket
(require rackunit)
(require rackunit/text-ui)
(require racket/include)
(include "simev.ss")
(require racket/trace)
(define minimal-maze
  '(
    (w   w   w)
      (w   0   w)
    (w   w   w)
    )
  )
(define minimal-maze_5marks
  '(
    (w   w   w)
      (w   5   w)
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
(define minimal-maze_with_space_marks_1
  '(
    (w   w   w   w   w)
      (w   1   2   w   w)
    (w   0   0   0   w)
      (w   0   5   w   w)
    (w   w   w   w   w)
    )
  )
(define minimal-maze_with_space_marks_2
  '(
    (w   w   w   w   w)
      (w   1   1   w   w)
    (w   1   1   1   w)
      (w   1   1   w   w)
    (w   w   w   w   w)
    )
  )
(define minimal-maze_with_space_marks_3
  '(
    (w   w   w   w   w)
      (w   4   0   w   w)
    (w   0   0   0   w)
      (w   0   4   w   w)
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


;Task 2
(define example1_prgs
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
(define example1_pairs
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
   (test-suite
    "evaluate"
    (test-suite
     "compare"
     (test-case "empty compare"
                (check-equal?
                 (comp_list '() '())
                 #f
                )
               )
     (test-case "first element compare"
                (check-equal?
                 (comp_list '(3) '(2))
                 #f
                )
               )
     (test-case "simple compare"
                (check-equal?
                 (comp_list '(1 2 3) '(1 2 3))
                 #f
                )
               )
     (test-case "simple compare2"
                (check-equal?
                 (comp_list '(2 2 3) '(1 2 3))
                 #f
                )
               )
     (test-case "not first element compare"
                (check-equal?
                 (comp_list '(1 2 3 4) '(1 2 3 3))
                 #f
                )
               )
     (test-case "not first element compare 2"
                (check-equal?
                 (comp_list '(1 2 3 3) '(1 2 3 4))
                 #t
                )
               )
     (test-case "result comparisonnot first element compare 2"
                (check-equal?
                 (compare-by-value '((1 2 3 3) apple) '((1 2 3 4) orange))
                 #t
                )
               )
     (test-case "not first element compare 2"
                (check-equal?
                 (compare-by-value '((1 2 4 4) apple) '((1 2 3 4) orange))
                 #f
                )
               )
    )
    (test-suite
     "sort"
     (test-case "empty list"
               (check-equal?
                (qsort  <= '())
                          '()
                )
               )
     (test-case "simple list"
               (check-equal?
                (qsort  <= '(2 3 1 5 4 6 8 7))
                          '(1 2 3 4 5 6 7 8)
                )
               )
    )
    (test-suite
     "manhattan-maze-dist"
     (test-case "pseudo maze"
               (check-equal?
                (manhattan-dist  '(0) '(1))
                          1
                )
      )
      (test-case "pseudo maze 2"
               (check-equal?
                (manhattan-dist  '(0 0 0) '(1 1 1))
                          3
                )
      )
      (test-case "pseudo maze 3"
               (check-equal?
                (manhattan-dist  '(0 0 w) '(1 1 w))
                          2
                )
      )
       (test-case "pseudo maze 4"
               (check-equal?
                (manhattan-dist  '(w 0 w) '(w 1 w))
                          1
                )
      )
       (test-case "pseudo maze 4 - symmetry"
               (check-equal?
                (manhattan-dist  '(w 1 w) '(w 0 w))
                          1
                )
      )
     (test-case "zero distance"
               (check-equal?
                (manhattan-dist  minimal-maze minimal-maze)
                          0
                )
      )
     (test-case "5 distance"
               (check-equal?
                (manhattan-dist  minimal-maze_5marks minimal-maze)
                          5
                )
               )
     (test-case "more marks"
               (check-equal?
                (manhattan-dist  minimal-maze_with_space_marks_1 minimal-maze_with_space_marks_2)
                          9
                )
      )
     (test-case "more marks"
               (check-equal?
                (manhattan-dist  minimal-maze_with_space_marks_3 minimal-maze_with_space_marks_2)
                          11
                )
      )
    )
    (test-suite
     "configuration distance"
     (test-case "zero distance"
               (check-equal?
                (config-dist '((()) (3 2) west) '((()) (3 2) west))
                0
                )
     )
     (test-case "position distance"
               (check-equal?
                (config-dist '((()) (2 3) west) '((()) (3 2) west))
                2
                )
     )
     (test-case "diff. orientation"
               (check-equal?
                (config-dist '((()) (3 2) west) '((()) (3 2) east))
                1
                )
     )
     (test-case "diff. orientation + position"
               (check-equal?
                (config-dist '((()) (0 0) east) '((()) (3 2) west))
                6
                )
     )
    )
    (test-suite
     "program length distance"
     (test-case "zero len"
               (check-equal?
                (prlen '())
                0
                )
     )
     (test-case "zero len 2 - pseudoprogram"
               (check-equal?
                (prlen '(procedure if ))
                0
                )
     )
     (test-case "simple nested -  pseudoprogram"
               (check-equal?
                (prlen '((procedure start (step step chocolate))(procedure chocolate (step turn-left))))
                7
                )
     )
     (test-case "example 1"
               (check-equal?
                (prlen '(procedure start (step step step put-mark)))
                5
                )
     )
     (test-case "example 2 "
               (check-equal?
                (prlen '(procedure start  (put-mark (if wall? turn-left step) start)))
                6
                )
     )
     )
     (test-suite
      "counting elements"
      (test-case "zero elements"
               (check-equal?
                (count_ele '())
                0
                )
       )
      (test-case "5elements"
               (check-equal?
                (count_ele '(1 apple 3 Alice 5))
                5
                )
       )
     )
     (test-suite
      "evaluate prog"
      (test-case "1 maze, simple procedure - runned_prog"
               (check-equal?
                (evaluate_runned_prog '((procedure start  (put-mark (if wall? turn-left step) start)))
                        '(((((w w w w w w) 
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
                           ))
                        '(20 20 20 20)
                        5
                        
                        )
                '(7 4 0 10)
                )
               )
     (test-case "2 mazes, 1 simple procedure"
               (check-equal?
                (evaluate_prog '((procedure start  (put-mark (if wall? turn-left step) start)))
                        '(((((w w w w w w) 
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
                        '(20 20 20 20)
                        5
                        
                        )
                '((18 8 6 20)((procedure start  (put-mark (if wall? turn-left step) start))))
                )
               )
    )
     (test-suite
      "evaluate function"
     (test-case "evaluate example 1"
                (check-equal?
                 (evaluate example1_prgs example1_pairs  '(20 20 20 20)  5)
                 '(
                   ((8 7 5 1) ((procedure start (step step step put-mark)))) 
                   ((18 8 6 20) ((procedure start (put-mark (if wall? turn-left step) start))))
                   )
                 )
     )
     )
    )
   )
  )
(run-tests maze-tests)

                        