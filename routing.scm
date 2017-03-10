(define (not-found request request-body)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))

(define (find-controller routes request request-body)
  (define (match? route path)
    (string-match (car route) path))
  (let ((path (uri-path (request-uri request))))
    (define (find-controller-iter routes)
      (cond
        ((null? routes) not-found)
        ((match? (car routes) path) (cadar routes))
        (else (find-controller-iter (cdr routes)))))
    (find-controller-iter routes)))

(define (find-and-run-controller routes request request-body)
  (let ((controller (find-controller routes request request-body)))
    (controller request request-body)))
