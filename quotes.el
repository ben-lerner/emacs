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
  (mapcar (lambda (i) (nth i data))
          (random-ints (length data) n)))

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

=================================================================================

"      )

(defun make-quote (quote-list)
  (concat (mapconcat (lambda (x) x) quote-list footer)
          footer))

(let ((quotes "~/quotes/quotes.txt")
      (perma-quotes "~/quotes/perma-quotes.txt")
      (default-quotes "~/emacs/default_quote.txt")
      (quotes-per-day 3))
  (setq initial-scratch-message
        (make-quote
         (append
          (get-n-random
           (eval-file
            (if (file-exists-p quotes)
              quotes
              default-quotes))
           quotes-per-day)
          (if (file-exists-p perma-quotes)
              (eval-file perma-quotes)
            '())))))

(defun goto-quotes ()
    (interactive)
    (find-file "~/quotes/quotes.txt"))
