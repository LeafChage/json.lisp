(in-package :cl-user)
(defpackage :ppp/defined
  (:use :cl)
  (:import-from :ppp/parser)
  (:import-from :ppp/many #:many)
  (:import-from :ppp/one-of #:one-of)
  (:import-from :ppp/token #:token)
  (:import-from :ppp/choice #:choice)
  (:export #:whitespace
           #:whitespaces
           #:digit
           #:letter))
(in-package :ppp/defined)

(defun whitespace ()
  (choice (token (string #\space))
          (token (string #\newline))
          (token (string #\tab))))

(defun whitespaces ()
  (many (whitespace)))

(defun digit ()
  (one-of "0123456789"))

(defun letter ()
  (one-of "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))


