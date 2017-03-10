(define (first pred l)
  (cond
    ((null? l) #nil)
    ((pred (car l)) (car l))
    (else (first pred (cdr l)))))
