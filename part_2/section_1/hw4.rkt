
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride)
  (cond ([< high low] null)
        (#t (cons low (sequence (+ low stride) high stride)))))

(define (string-append-map xs suffix)
  (map (lambda (s) (string-append s suffix)) xs))

(define (list-nth-mod xs n)
  (cond ([< n 0] (error "list-nth-mod: negative number"))
        ([empty? xs] (error "list-nth-mod: empty list"))
        (#t (car (list-tail xs (remainder n (length xs)))))))

(define (stream-for-n-steps s n)
  (cond [(= n 0) null]
        [#t (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))]))

(define funny-number-stream
  (letrec ([g (lambda (i) (cond [(eq? (remainder i 5) 0) (- 0 i)]
                                [#t i]))]
           [f (lambda (x) (cons (g x) (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

(define dan-then-dog
  (letrec ([f (lambda () (cons "dan.jpg" (lambda () (g))))]
           [g (lambda () (cons "dog.jpg" (lambda () (f))))])
    (lambda () (f))))

(define (stream-add-zero s)
  (lambda () (cons (cons 0 (car (s)))
                   (stream-add-zero (cdr (s))))))

(define (cycle-lists xs ys)
  (letrec ([f (lambda (n) (cons
                           (cons (list-nth-mod xs n) (list-nth-mod ys n))
                           (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

; if vector AND if matches return value
; if vector BUT does not match move ahead
; if nothing here, return #f

(define (vector-assoc v vec)
  (letrec ([f (lambda (n) (if (>= n (vector-length vec))
                              #f
                              (let ([x (vector-ref vec n)])
                                (if (and (pair? x) (equal? (car x) v))
                                    x
                                    (f (+ n 1))))))])
    (f 0)))

; vector-length
; vector-ref (vec, n)
; equal?
         
; assoc X LST
; matches first pair in LST with car of pair = X

; make a vector of N values, all #f by default
; (make-vector n #f)

; return a function that takes v and returns the same thing that vector-assoc v xs does
; (f v))

(define (cached-assoc xs n)
  (letrec ([memo (make-vector n #f)]
           [idx 0]
           [f (lambda (v)
                (let ([ans [vector-assoc v memo]])
                  (if ans
                      (cdr ans)
                      (let ([new-ans (assoc v xs)])
                        (begin
                          (vector-set! memo idx new-ans)
                          (set! idx (remainder n (+ idx 1)))
                          new-ans)))))])
    f))

  