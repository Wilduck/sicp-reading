;; Exercise 3.70.  It would be nice to be able to generate streams in
;; which the pairs appear in some useful order, rather than in the
;; order that results from an ad hoc interleaving process. We can use
;; a technique similar to the merge procedure of exercise 3.56, if we
;; define a way to say that one pair of integers is ``less than''
;; another. One way to do this is to define a ``weighting function''
;; W(i,j) and stipulate that (i1,j1) is less than (i2,j2) if W(i1,j1)
;; < W(i2,j2). Write a procedure merge-weighted that is like merge,
;; except that merge-weighted takes an additional argument weight,
;; which is a procedure that computes the weight of a pair, and is
;; used to determine the order in which elements should appear in the
;; resulting merged stream. Using this, generalize pairs to a
;; procedure weighted-pairs that takes two streams, together with a
;; procedure that computes a weighting function, and generates the
;; stream of pairs, ordered according to weight. Use your procedure to
;; generate

;; a. the stream of all pairs of positive integers (i,j) with i < j
;; ordered according to the sum i + j

;; b. the stream of all pairs of positive integers (i,j) with i < j,
;; where neither i nor j is divisible by 2, 3, or 5, and the pairs are
;; ordered according to the sum 2 i + 3 j + 5 i j.

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((< (weight s1car) (weight s2car))
                  (stream-cons s1car (merge-weighted (stream-cdr s1) s2 weight)))
                 ((> (weight s1car) (weight s2car))
                  (stream-cons s2car (merge-weighted (stream-cdr s2) s1 weight)))
                 (else
                  (stream-cons s1car
                               (merge-weighted (stream-cdr s1)
                                               s2
                                               weight))))))))


(define (weighted-pairs s1 s2 weight)
  (stream-cons (list (stream-car s1) (stream-car s2))
               (merge-weighted (stream-map (lambda (x) (list (stream-car s1) x))
                                           (stream-cdr s2))
                               (weighted-pairs (stream-cdr s1) (stream-cdr s2) weight)
                               weight)))

;; The above obviously doesn't work. See:
(take 10 (weighted-pairs integers integers (lambda (x) (car x))))

(take 10 (weighted-pairs integers integers (lambda (x) (apply + x))))

(merge-weighted integers integers (lambda (x) (apply + x)))

;;;;;;;;;;;;;;;

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((cars1 (stream-car s1))
               (cars2 (stream-car s2)))
           (cond ((< (weight cars1) (weight cars2))
                  (stream-cons cars1 
                               (merge-weighted (stream-cdr s1) s2 weight)))
                 ((= (weight cars1) (weight cars2)) 
                  (stream-cons cars1 
                               (merge-weighted (stream-cdr s1) s2 weight)))
                 (else (stream-cons cars2
                                    (merge-weighted s1 (stream-cdr s2) weight))))))))

(define (weighted-pairs s1 s2 weight)
  (stream-cons (list (stream-car s1) (stream-car s2))
               (merge-weighted (stream-map (lambda (x) (list (stream-car s1) x))
                                           (stream-cdr s2))
                               (weighted-pairs (stream-cdr s1) (stream-cdr s2) weight)
                               weight)))


(define weight1 (lambda (x) (+ (car x) (cadr x))))
(define pairs1 (weighted-pairs integers integers weight1))
