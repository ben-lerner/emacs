(defun get-n-random (data n)
  (if (<= n 0)
      '()
      (mapcar (lambda (i) (nth i data))
              (random-ints (length data) n))))

(defun random-ints (n k)
  ;; generates up to k unique random ints in [0, n)
  (if (or (<= k 0) (<= n 0))
      '()
    (let ((rest (random-ints n (- k 1)))
          (new (random n)))
      (delete-dups (cons new rest)))))

(defun read-file (file)
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(defun eval-file (file)
  (eval (car (read-from-string (read-file file)))))

(setq footer
"

==============================================================================

"      )

(defun make-quote (quote-list)
  (concat (mapconcat (lambda (x) x) quote-list footer)
          footer))

(let* ((quotes-per-day 3)
       (quotes-file "~/quotes/quotes.txt")
       (default-quotes-file "~/emacs/default_quote.txt")
       (quotes
        (if (file-exists-p quotes-file)
            (eval-file quotes-file)
            (eval-file default-quotes-file)))
       (perma-quotes-file "~/quotes/perma-quotes.txt")
       (perma-quotes
        (if (file-exists-p perma-quotes-file)
            (eval-file perma-quotes-file)
            '())))
  (setq initial-scratch-message
        (make-quote
         (append
          (get-n-random
           quotes
           quotes-per-day  ;; (- quotes-per-day (length perma-quotes))
           )
          perma-quotes))))

(defun goto-quotes ()
    (interactive)
    (find-file "~/quotes/quotes.txt"))
