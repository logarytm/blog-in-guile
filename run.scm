(use-modules (ice-9 regex))
(use-modules (web server))
(use-modules (web request)
             (web response)
             (web uri))

(define (request-path-components request)
  (split-and-decode-uri-path (uri-path (request-uri request))))

(define (trivial-response text)
  (values '((content-type . (text/plain)))
          text))

(define (hello-controller request request-body)
  (trivial-response "Hello, World!"))

(define (not-found request request-body)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))

(define *routes*
  `(("^/$" ,hello-controller)))

(define (match? route uri)
  (string-match (car route) uri))

(define (find-controller request request-body)
  (let ((uri (uri-path (request-uri request))))
    (define (find-controller-iter routes)
      (let ((route (car routes)))
        (cond
          ((null? routes) not-found)
          ((match? route uri) (cadr route))
          (else (find-controller-iter (cdr routes))))))
    (find-controller-iter *routes*)))

(define (main-handler request request-body)
  ((find-controller request request-body) request request-body))

(run-server main-handler)
