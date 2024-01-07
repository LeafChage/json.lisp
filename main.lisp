(in-package :cl-user)
(defpackage json
  (:use :cl
        :alexandria
        :pigeon)
  (:import-from :ppp)
  (:import-from :uiop #:read-file-string))
(in-package :json)

(defun p-true ()
  (ppp:token "true"))
;; (ppp:parse (p-true) "failed")
;; (ppp:parse (p-true) "true")

(defun p-false ()
  (ppp:token "false"))
;; (ppp:parse (p-false) "failed")
;; (ppp:parse (p-false) "false")

(defun p-null ()
  (ppp:token "null"))
;; (ppp:parse (p-null) "failed")
;; (ppp:parse (p-null) "null")

(defun p-number ()
  (ppp:->
    (ppp:&&
      (ppp:option (ppp:token "-"))
      (ppp:|| (ppp:token "0")
              (ppp:&& (ppp:one-of "123456789")
                      (ppp:many (ppp:digit))))
      (ppp:option (ppp:&& (ppp:token ".")
                          (ppp:many (ppp:digit))))
      (ppp:option (ppp:&&
                    (ppp:|| (ppp:token "E")
                            (ppp:token "e"))
                    (ppp:option (ppp:|| (ppp:token "+")
                                        (ppp:token "-")))
                    (ppp:many (ppp:digit)))))
    (lambda (v) (apply #'concatenate 'string (flatten v)))))

;; (ppp:parse (p-number) "-1 h")
;; (ppp:parse (p-number) "-0")
;; (ppp:parse (p-number) "0")
;; (ppp:parse (p-number) "1 h")
;; (ppp:parse (p-number) "11000 h")
;; (ppp:parse (p-number) "11000.111 h")
;; (ppp:parse (p-number) "-11000.111 h")
;; (ppp:parse (p-number) "-11000.111E100 h")

(defun p-string ()
  (ppp:->
    (ppp:with
      (ppp:token "\"")
      (ppp:skip (ppp:until (ppp:choice (ppp:-> (ppp:token "\\\"") (lambda (_) (string #\")))
                                       (ppp:token "\\\\")
                                       (ppp:token "\\/")
                                       (ppp:token "\\b")
                                       (ppp:token "\\f")
                                       (ppp:-> (ppp:token "\\n")(lambda (_) (string #\newline)))
                                       (ppp:token "\\r")
                                       (ppp:-> (ppp:token "\\t")(lambda (_) (string #\tab)))
                                       (ppp:check (ppp:any)
                                                  (lambda (v) (not (string= v "\"")))))
                           (ppp:token "\""))
                (ppp:token "\"")))
    (lambda (v) (apply #'concatenate 'string (flatten v)))))
;; (ppp:parse (p-string) "\"hello\"")
;; (ppp:parse (p-string) "\"he\\\"hi\"")
;; (ppp:parse (p-string) "\"he\\\\hi\\\"hihihihi\"")
;; (ppp:parse (p-string) "hihihhii\"123")

(defun p-array ()
  (ppp:with
    (ppp:token "[")
    (ppp:skip (ppp:|| (ppp:-> (ppp:&& (p-value)
                                      (ppp:many (ppp:with (ppp:token ",")
                                                          (p-value))))
                              (lambda (v) (cons (car v) (cadr v))))
                      (ppp:whitespaces))
              (ppp:token "]"))))

;; (ppp:parse (p-array) "[ ]")
;; (ppp:parse (p-array) "[ true, false, null ]")
;; (ppp:parse (p-array) "[  1, 2,3  ]")

(defun p-value ()
  (ppp:with
    (ppp:whitespaces)
    (ppp:skip
      (ppp:choice
        (p-string)
        (p-number)
        (ppp:lazy #'p-object)
        (ppp:lazy #'p-array)
        (p-true)
        (p-false)
        (p-null))
      (ppp:whitespaces))))
;; (ppp:parse (p-value) " true hi")
;; (ppp:parse (p-value) " false ")
;; (ppp:parse (p-value) " null ")

(defun p-object-inner ()
  (ppp:with
    (ppp:whitespaces)
    (ppp:&& (p-string)
            (ppp:with (ppp:&& (ppp:whitespaces)
                              (ppp:token ":"))
                      (p-value)))))
(defun p-object ()
  (ppp:with
    (ppp:token "{")
    (ppp:skip (ppp:choice
                (ppp:-> (ppp:&& (p-object-inner)
                                (ppp:many (ppp:with (ppp:token ",")
                                                    (p-object-inner))))
                        (lambda (key-values)
                          (loop for v in (cons (car key-values) (cadr key-values))
                                collect (list (make-symbol (car v))  (cadr v)))))
                (ppp:whitespaces))
              (ppp:token "}"))))

;; (let ((text (uiop:read-file-string "./sample.json")))
  ;; (car (result:unwrap (ppp:parse (p-object) text))))


