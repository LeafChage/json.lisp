(in-package :cl-user)
(defpackage :ppp/one-of
  (:use :cl
        :alexandria
        :pigeon)
  (:import-from #:ppp/parser)
  (:import-from #:ppp/error)
  (:import-from #:ppp/util)
  (:export #:one-of))
(in-package :ppp/one-of)

(defclass one-of-parser (ppp/parser:parser)
  ((target :INITARG :target)))

(defmethod ppp/parser:parse ((p one-of-parser)
                             (text sequence))
  (with-slots ((target target)) p
    (if (not (> (length text) 0))
        (ppp/error:parser-err :expect target
                              :actual "")
        (let ((v (ppp/util:split text 1)))
          (if (str:contains? (car v) target)
              (result:ok v)
              (ppp/error:parser-err :expect target
                                    :actual (car v)))))))


(defmethod one-of ((target sequence))
  (make-instance 'one-of-parser :target target))

