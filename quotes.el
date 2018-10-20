(defun drop-leading-zero (s)
  (if (string= (substring s 0 1) "0")
	  (substring s 1)
	  s))

(defun todays-date ()
  ;; e.g. 1-15-16.txt
  (let ((date (seconds-to-time (- (float-time) (* 6 60 60)))))
	     ; what date was it 6 hours ago? up to 6 am
	(concat (drop-leading-zero (format-time-string "%m" date))
			"-"
			(drop-leading-zero (format-time-string "%d" date))
			"-"
			(format-time-string "%y" date))))


(defun get-n-random (data n)
  (if (<= n 0)
      '()
      (mapcar (lambda (i) (nth i data))
              (random-ints (length data) n))))

(defun random-ints (n k) ;; give k seeded random integers in [0, n), repeated and de-duped
  (delete-dups
   (mapcar (lambda (i)
             (mod
              (random (concat (todays-date) (number-to-string i)))
              n))
           (number-sequence 1 k))))

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

(let* ((quotes-per-day 2)
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
