(in-package :cl-user)
(defpackage :ppp/until
  (:use :cl
        :alexandria
        :pigeon)
  (:import-from #:ppp/parser)
  (:export #:until))
(in-package :ppp/until)

(defclass until-parser (ppp/parser:parser)
  ((child :INITARG :child)
   (check :INITARG :check)))

(defmethod ppp/parser:parse ((p until-parser)
                             (text sequence))
  (with-slots ((child child) (check check)) p
    (result:->> (ppp/parser:parse child text)
                (lambda (v)
                  (result:match (ppp/parser:parse check (cadr v))
                    (lambda (_) (result:ok v))
                    (lambda (_)
                      (result:-> (ppp/parser:parse p (cadr v))
                                 (lambda (v2)
                                   (list
                                     (cons (car v) (car v2))
                                     (cadr v2))))))))))


(defmethod until ((child ppp/parser:parser)
                  (check ppp/parser:parser))
  (make-instance 'until-parser :child child :check check))


