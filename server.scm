(use-modules (ice-9 regex))
(use-modules (web server))
(use-modules (web request)
             (web response)
             (web uri))
(load "routing.scm")

(define (trivial-response text)
  (values '((content-type . (text/plain)))
          text))

(define (hello-controller request request-body)
  (trivial-response "Hello, World!"))

(define *routes*
  `(("^/$" ,hello-controller)))

(define (main-handler request request-body)
  (find-and-run-controller *routes* request request-body))

(run-server main-handler)
