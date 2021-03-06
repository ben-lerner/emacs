;; keep other modes from overwriting global commands:
;; todo: clean this up to use bind-key
(use-package bind-key)

;; Window splitting
(defun vertical-panes (n)
  (delete-other-windows)
  (setq panes 1)
  (while (< panes n)
    (split-window-right)
    (setq panes (1+ panes)))
  (balance-windows))

(defun doubled-panes (n)
  (setq n (/ n 2))
  (vertical-panes n)
  (defun split-pane ()
    ;; split current pane, move to next
    ;; gets back to top-left when all are split
    (split-window-below)
    (select-next-window)
    (select-next-window))
  (setq split-panes 0)
  (while (< split-panes n)
    (split-pane)
    (setq split-panes (1+ split-panes))))

(bind-key* "C-1" 'delete-other-windows)
(bind-key* "C-2" 'split-window-below)
(bind-key* "C-3" 'split-window-right)
(bind-key* "C-=" 'balance-windows)
(bind-key* "C-7" 'toggle-frame-fullscreen)
(bind-key* "C-0" 'delete-window)

(bind-key* "C-6"
           (lambda () ;; three vertical panes
             (interactive)
             (vertical-panes 3)))

(bind-key* "C-x 1" 'delete-other-windows)
(bind-key* "C-x 2" 'split-window-below)
(bind-key* "C-x 3" 'split-window-right)
(bind-key* "C-x =" 'balance-windows)
(bind-key* "C-x 7" 'toggle-frame-fullscreen)
(bind-key* "C-x 0" 'delete-window)

(bind-key* "C-x 6"
           (lambda () ;; three vertical panes
             (interactive)
             (vertical-panes 3)))

;; errors
(bind-key  "C-~" 'previous-error)
(bind-key  "C-`" 'next-error)

;; undo
(bind-key "C-/" 'undo-tree-undo)
(bind-key "M-/" 'undo-tree-redo)
(unbind-key "C-_")

;; for quotes
(defun right-justify ()
  (interactive)
  (move-beginning-of-line nil)
  (let ((cur-len (-  (length (thing-at-point 'line t)) 1))) ; drop newline
    (insert-char ?  (- 79 cur-len))) ; add one for end quote. "? " = space char
  )

(bind-key* "C-M-j" 'right-justify)

;; case
(defun toggle-case ()
  (interactive)
  (when (region-active-p)
    (let ((i 0)
      (return-string "")
      (input (buffer-substring-no-properties (region-beginning) (region-end))))
      (while (< i (- (region-end) (region-beginning)))
    (let ((current-char (substring input i (+ i 1))))
      (if (string= (substring input i (+ i 1)) (downcase (substring input i (+ i 1))))
          (setq return-string
            (concat return-string (upcase (substring input i (+ i 1)))))
        (setq return-string
          (concat return-string (downcase (substring input i (+ i 1)))))))
    (setq i (+ i 1)))
      (delete-region (region-beginning) (region-end))
      (insert return-string))))

(defun toggle-case-at-point ()
  (interactive)
  (set-mark-command nil)
  (forward-char)
  (toggle-case))

(bind-key* "M-t" 'toggle-case-at-point)

;; install zone-pgm-rainbow
;; random
(setq zone-programs [zone-pgm-rainbow])
(bind-key* "C-M-z" 'zone)

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(bind-key* "C-x C-r" 'rename-current-buffer-file)
(bind-key* "C-c C-f" 'ffap) ; find file at point

(defun drop-leading-zero (s)
  (if (string= (substring s 0 1) "0")
	  (substring s 1)
	  s))

(defun todays-date ()
  ;; e.g. 3-18-16.txt
  (let ((date (seconds-to-time (- (float-time) (* 6 60 60)))))
	     ; what date was it 6 hours ago? up to 6 am
	(concat (drop-leading-zero (format-time-string "%m" date))
			"-"
			(drop-leading-zero (format-time-string "%d" date))
			"-"
			(format-time-string "%y" date))))

;; spelling
(bind-key* "C-c p" 'ispell-word)

(bind-key* "M-c" 'centered-window-mode)

;; better replace and replace-regexp commands
(bind-key* "C-\\" 'query-replace)
(bind-key* "M-\\" 'query-replace-regexp)

;; replace and replace-regexp for token at point
(defun replace-at-point ()
  (interactive)
  (let ((from (thing-at-point 'word)))
    (query-replace from (read-string (concat "Replace \"" from "\" with: ")))))

(bind-key* "C-|" 'replace-at-point)

(bind-key* "C-z" 'zap-up-to-char)
(bind-key* "C-S-z" 'zap-past-char)
(bind-key* "M-z" 'go-to-char)

;;; global commands
;; more intuitive M-f and M-S_f behavior: stops at start of word/sexp, not before
(global-set-key (kbd "M-f") 'forward-to-word)
(bind-key* "M-F" 'forward-word)

(defun forward-to-sexp ()
  (interactive)
  (let ((start (point)))
    (forward-sexp)
    (backward-sexp)
    (when (>= start (point))  ;; at the beginning of sexp or in a token, so the above is a no-op
      (forward-sexp)
      (forward-sexp)
      (backward-sexp))))

(bind-key* "C-M-f" 'forward-to-sexp)
(bind-key* "C-M-F" 'forward-sexp)

;; don't ask about killing running process
(bind-key* "C-x k"
           (lambda ()
             (interactive)
             (kill-buffer (buffer-name))))

(setq kill-buffer-query-functions
      (delq 'process-kill-buffer-query-function
			kill-buffer-query-functions))

;; UI helpers

; outline line (=== above and below)

(defun main-header ()
  (interactive)
  (make-header ?=))

(defun side-header ()
  (interactive)
  (make-header ?-))

(defun make-double-header (header-char)
  (interactive)
  (setq temp-newline-and-indent newline-and-indent)
  (setq newline-and-indent ())

  (open-previous-line 1)
  (next-line)
  (open-next-line 1) ; do this first to make sure newline is present when
					 ; counting length
  (previous-line)

  (setq L (- (length (thing-at-point 'line)) 1))
  (setq header-str (make-string L header-char))

  (previous-line)
  (insert header-str)
  (next-line)
  (next-line)
  (insert header-str)
  (next-line)
  (setq newline-and-indent temp-newline-and-indent))

(defun make-header (header-char)
  (interactive)
  (setq temp-newline-and-indent newline-and-indent)
  (setq newline-and-indent ())

  (open-next-line 1) ; do this first to make sure newline is present when
					 ; counting length
  (previous-line)

  (setq L (- (length (thing-at-point 'line)) 1))
  (setq header-str (make-string L header-char))

  (next-line)
  (insert header-str)
  (next-line)
  (setq newline-and-indent temp-newline-and-indent))

(defun current-line-empty-p ()
  (save-excursion
	(beginning-of-line)
	(looking-at "[[:space:]]*$")))

(defun top-of-buffer-p ()
  (save-excursion
	(= (point)
	   (progn
		 (previous-line)
		 (point)))))

(defun top-of-paragraph-p ()
  ;; are we at the top line of a paragraph?
  (or (top-of-buffer-p)
	  (save-excursion
		(previous-line)
		(current-line-empty-p))))

(defun paste-prep-paragraph ()
  ; turns the current paragraph into a single line, in preparation for pasting
  ; text to an external program
  (interactive)
  (save-excursion
	(forward-paragraph) ; bottom of paragraph
	(if (current-line-empty-p)
		(previous-line)) ; we're usually on an empty line, unless it's the
						 ; bottom of the window

	(while (not (top-of-paragraph-p))
	  (delete-indentation))))

;;; better new-lines
(defvar newline-and-indent t)

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer t t))

(defun comment-or-uncomment-paragraph ()
  (interactive)
  (let ((start (point)))
    (forward-paragraph)
    (comment-or-uncomment-region start (point))))

(bind-key* "C-q" 'delete-indentation)
(bind-key* "M-^" 'paste-prep-paragraph)
(bind-key* "C-c C-v" 'revert-buffer-no-confirm)
(bind-key* "M-;" 'comment-or-uncomment-region)
(bind-key* "M-:" 'comment-or-uncomment-paragraph)
(bind-key* "C-c C-q" 'auto-fill-mode)

(bind-key* "C-_" 'main-header)  ; markdown h1
(bind-key* "C--" 'side-header)  ; markdown h2
(unbind-key "C-c l" 'nil)
(unbind-key "C-c n" 'nil)
(unbind-key "C-c j" 'nil)

;; fun stuff
(defun add-to-number-at-point (n)
      (skip-chars-backward "0-9")
      (or (looking-at "[0-9]+")
          (error "No number at point"))
      (replace-match (number-to-string
					  (+ (string-to-number (match-string 0)) n)))
	  (backward-char))


(defun decrement-number-at-point ()
      (interactive)
	  (add-to-number-at-point -1))

(defun increment-number-at-point ()
      (interactive)
	  (add-to-number-at-point 1))

(bind-key* "C-c +" 'increment-number-at-point)
(bind-key* "C-c -" 'decrement-number-at-point)

(defun w3mext-open-link-or-image-or-url ()
  "Opens the current link or image or current page's uri or any url-like text under cursor in firefox."
  (interactive)
  (let (url)
    (if (string= major-mode "w3m-mode")
        (setq url (or (w3m-anchor) (w3m-image) w3m-current-url)))
    (browse-url-generic (if url url (car (browse-url-interactive-arg "URL: "))))
    ))

(bind-key* "C-c b" 'w3mext-open-link-or-image-or-url)

;; delete current file and kill buffer

(defun nuke-file ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (save-buffer) ;; prevent prompt
  (let ((filename (buffer-file-name)))
    (when filename
      (progn
        (delete-file filename)
        (message "Deleted file %s" filename)
        (kill-buffer)))))

;; drop commands
(unbind-key "C-x C-z") ;; no more accidentally shrinking windows

;; todo: figure out filter
(defun real-buffers (buffers)
    (cond ((null buffers) buffers)
          ((real-buffer (buffer-name (car buffers)))
           (cons (car buffers) (real-buffers (cdr buffers))))
          (t (real-buffers (cdr buffers)))))

(defun real-buffer (buffer) (not (or (string-prefix-p " *" buffer)
                                     (string-prefix-p "*" buffer))))

(bind-key* "C-S-s" (lambda ()
                     (interactive)
                     (multi-occur
                      (real-buffers (buffer-list))
                      (car (occur-read-primary-args)))))

;; lisp Eval
(defun replace-last-sexp ()
    (interactive)
    (let ((value (eval (preceding-sexp))))
      (kill-sexp -1)
      (insert (format "%S" value))))

(bind-key* "C-M-e" 'replace-last-sexp)

(bind-key* "C-S-k" 'kill-whole-line)
(bind-key* "M-k" 'kill-paragraph)

(defun join-line-with-space ()
  (interactive)
  (join-line)
  (insert " "))

(bind-key* "C-M-q" 'join-line-with-space)

;; faster keystroke for the most common command
(bind-key* "C-x C-x" 'save-buffer)
(unbind-key "C-x C-s")

;; don't prompt for directory on ag
(defun grp (string)
  (interactive (list (ag/read-from-minibuffer "Search for")))
  (ag/search string default-directory))

(require 'cl-lib)

(defun kill-buffers-in-dir (dirname)
  "Kill all buffers in dirname."
  (interactive "sdirname: ")
  (let ((buffers
         (cl-remove-if-not
          (lambda (buffer)
            (string-prefix-p dirname (buffer-file-name buffer)))
          (buffer-list))))
    (if (= (length buffers) 1)
        (message "Killing 1 buffer")
        (message "Killing %s buffers" (length buffers)))
    (mapc 'kill-buffer buffers)))

;; mimic regular yank-pop's replace
(defun counsel-yank-pop-with-replace ()
  (interactive)
  (when (eq last-command 'yank)
    (undo)
    (undo))
  (counsel-yank-pop))
