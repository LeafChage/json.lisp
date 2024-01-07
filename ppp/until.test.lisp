
(in-package ppp/test)

(test test-until
  (is (@eq (parse (until (digit) (token "hi")) "12345hi12345")
           (result:ok '(("1" "2" "3" "4" . "5") "hi12345"))))

  (is-false (result:ok? (parse (until (digit) (token "hi")) "hi")))

  (is-false (result:ok? (parse (until (digit) (token "hi")) "12345")))
  )

(run! 'test-until)



