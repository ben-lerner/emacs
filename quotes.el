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


(defun random-index (n) ;; gives a seeded random index in [0, n)
  (mod (random (todays-date)) n))

(defun get-random-element (list) ;; uses a seed
  (nth (random-index (length list)) list))

(defun drop-nth (list n)
  (if (= n 0)
      (cdr list)
    (cons (car list) (drop-nth (cdr list) (- n 1)))))

(defun get-n-random (list n)
  (if (or (= n 0) (null list))
      '()
    (let ((i (random-index (length list))))
      (cons (nth i list)
            (get-n-random (drop-nth list i) (- n 1))))))


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
      (default-quotes "~/emacs/default_quote.txt"))
  (setq initial-scratch-message
        (make-quote
         (append
          (get-n-random
           (eval-file
            (if (file-exists-p quotes)
              quotes
              default-quotes))
           2)
          (if (file-exists-p perma-quotes)
              (eval-file perma-quotes)
            '())))))

(defun goto-quotes ()
    (interactive)
    (find-file "~/quotes/quotes.txt"))
