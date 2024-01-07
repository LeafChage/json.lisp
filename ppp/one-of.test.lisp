(in-package ppp/test)

(test test-one-of
  (is (@eq (parse (one-of "12345") "123")
           (result:ok '("1" "23"))))

  (is-false (result:ok? (parse (one-of "12345") "")))
  (is-false (result:ok? (parse (one-of "12345") "hello"))))

;; (run! 'test-one-of)
