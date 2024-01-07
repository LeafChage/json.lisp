(in-package :ppp/test)

(test test-whitespace
  (is (@eq (parse (whitespace) " 123")
           (result:ok '(" " "123"))))

  (is-false (result:ok? (parse (whitespace) "123")))
  )
;; (run! 'test-whitespace)


(test test-whitespaces
  (is (@eq (parse (whitespaces) "  123")
           (result:ok '((" " " ") "123"))))
  (is-true (result:ok? (parse (whitespaces) "123"))))

;; (run! 'test-whitespaces)

(test test-digit
  (is (@eq (parse (digit) "123")
           (result:ok '("1" "23"))))

  (is-false (result:ok? (parse (digit) "")))
  (is-false (result:ok? (parse (digit) "hello"))))

;; (run! 'test-digit)

(test test-letter
  (is (@eq (parse (letter) "hello")
           (result:ok '("h" "ello"))))

  (is-false (result:ok? (parse (letter) "")))
  (is-false (result:ok? (parse (letter) "12345"))))

;; (run! 'test-letter)
