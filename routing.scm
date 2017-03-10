(load "util.scm")

(define (not-found request request-body)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))

(define (find-controller routes request request-body)
  (define (match? route)
    (string-match (car route) (uri-path (request-uri request))))
  (let ((route (first match? routes)))
    (if (null? route) not-found (cadr route))))

(define (find-and-run-controller routes request request-body)
  (let ((controller (find-controller routes request request-body)))
    (controller request request-body)))
