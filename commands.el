;; keep other modes from overwriting global commands:
;; todo: clean this up to use bind-key
(use-package bind-key)
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap")
(defvar my-tab-minor-mode-map (make-keymap) "my-tab-minor-mode keymap")


;; Window splitting
(bind-key* "C-0" 'delete-window)
(bind-key*  "C-1" 'delete-other-windows)
(bind-key*  "C-2" 'split-window-below)
(bind-key*  "C-3" 'split-window-right)
(bind-key*  "C-+" 'balance-windows)
(bind-key*  "C-4" (kbd "C-1 C-3 C-3 C-+"))

;; errors
(bind-key  "C-~" 'previous-error)
(bind-key*  "C-`" 'next-error)

;; for quotes
(defun right-justify ()
  (interactive)
  (move-beginning-of-line nil)
  (let ((cur-len (-  (length (thing-at-point 'line t)) 1))) ; drop newline
    (insert-char ?  (- 80 cur-len))) ; add one for end quote. "? " = space char
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

(bind-key* "M-t" ;; toggle case of char at point
           (lambda ()
             (interactive)
             (set-mark-command nil)
             (forward-char)
             (toggle-case)
             (backward-char)))

;; scroll by half page
(defun zz-scroll-half-page (direction)
  "Scrolls half page up if `direction' is non-nil, otherwise will scroll half page down."
  (let ((opos (cdr (nth 6 (posn-at-point)))))
    ;; opos = original position line relative to window
    (move-to-window-line nil)  ;; Move cursor to middle line
    (if direction
        (recenter-top-bottom -1)  ;; Current line becomes last
      (recenter-top-bottom 0))  ;; Current line becomes first
    (move-to-window-line opos)))  ;; Restore cursor/point position

(defun zz-scroll-half-page-down ()
  "Scrolls exactly half page down keeping cursor/point position."
  (interactive)
  (zz-scroll-half-page nil))

(defun zz-scroll-half-page-up ()
  "Scrolls exactly half page up keeping cursor/point position."
  (interactive)
  (zz-scroll-half-page t))

(bind-key* "C-v" 'zz-scroll-half-page-down)
(bind-key* "M-v" 'zz-scroll-half-page-up)

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

;; set "capitalize-word" to move to beginning of current word
(bind-key* "M-c"
           (lambda ()
             (interactive)
             (backward-word)
             (capitalize-word 1)))

;; Navigation
(bind-key* "M-]" 'select-next-window)
(bind-key* "M-[" 'select-previous-window) ;; *don't* remap C-[
(use-package transpose-frame)

(bind-key* "C-x t" 'rotate-frame) ; 'transpose'
(define-key my-keys-minor-mode-map (kbd "M-SPC") (kbd "M-4 SPC"))

;; better replace and replace-regexp commands
(bind-key* "C-\\" 'query-replace)
(bind-key* "M-\\" 'query-replace-regexp)

(bind-key* "C-z" 'zap-up-to-char)
(bind-key* "M-z" 'go-to-char)

;; find the next/previous instance of token under cursor
(require 'evil)

(bind-key* "M-N" 'evil-search-word-forward)
(bind-key* "M-P" 'evil-search-word-backward)

; navigate by paragraphs
(define-key my-tab-minor-mode-map "\M-n" 'forward-paragraph)
(define-key my-tab-minor-mode-map "\M-p" 'backward-paragraph)
(define-key my-tab-minor-mode-map (kbd "C-<return>") (kbd "C-x C-s C-c C-a"))
; kill entire line
(bind-key* "C-'" (kbd "C-a C-k C-k"))

;;; global commands

(bind-key* "C-x k" 'kill-this-buffer) ; don't ask which buffer
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function
										kill-buffer-query-functions))
										  ; don't ask about running process

;; UI helpers

; outline line (=== above and below)

(defun make-main-header ()
  (interactive)
  (make-header ?=))

(defun make-side-header ()
  (interactive)
  (make-header ?-))

(defun make-header (header-char)
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
  (setq newline-and-indent temp-newline-and-indent)
  )

(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))

(defun zap-up-to-char (arg char)
  "Kill up to, but not including ARGth occurrence of CHAR.
   Case is ignored if `case-fold-search' is non-nil in the current buffer.
   Goes backward if ARG is negative; error if CHAR not found.
   Ignores CHAR at point."
   (interactive "p\ncZap up to char: ")
   (let ((direction (if (>= arg 0) 1 -1)))
     (kill-region (point)
                  (progn
                    (forward-char direction)
                    (unwind-protect
                        (search-forward (char-to-string char) nil nil arg)
                      (backward-char direction))
                    (point)))))

(defun open-next-line (arg)
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

(defun open-previous-line (arg)
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

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

(defun go-to-char (arg char)
  "Analagous to zap, but just moves."
  (interactive "p\ncMove up to char: ")
  (let ((direction (if (>= arg 0) 1 -1)))
    (forward-char direction) ;; move to next char if you're already on an instance
    (search-forward (char-to-string char) nil nil arg)
    (backward-char direction)))


(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer t t))

(defun term-dabbrev-expand ()
  (interactive)
  (let ((beg (point)))
    (dabbrev-expand nil)
    (kill-region beg (point)))
  (term-send-raw-string (substring-no-properties (current-kill 0))))

(defun my-dabbrev-expand ()
  (interactive)
  (if (string= major-mode "term-mode")
      (term-dabbrev-expand)
    (dabbrev-expand nil)))

(global-set-key (kbd "C-<tab>") 'my-dabbrev-expand) ; default
(define-key my-keys-minor-mode-map (kbd "C-<tab>") 'my-dabbrev-expand)
(setq dabbrev-case-fold-search nil)
(define-key my-tab-minor-mode-map (kbd "C-<tab>") 'indent-for-tab-command)
(define-key my-tab-minor-mode-map (kbd "<tab>") 'my-dabbrev-expand)

(define-key my-keys-minor-mode-map (kbd "C-c C-l")
  (lambda ()
	(interactive)
	(load-file "~/emacs/init.el")  ; reload .emacs
	(revert-buffer-no-confirm) ; revert current buffer
	))

(define-key my-keys-minor-mode-map (kbd "C-q") 'delete-indentation)
(define-key my-keys-minor-mode-map (kbd "M-^") 'paste-prep-paragraph)
(define-key my-keys-minor-mode-map (kbd "C-c C-v") 'revert-buffer-no-confirm)
(define-key my-keys-minor-mode-map (kbd "C-c ]") 'comment-region) ; for scheme mode
(define-key my-keys-minor-mode-map (kbd "C-c [") 'uncomment-region) ; for scheme mode
;(define-key my-keys-minor-mode-map (kbd "C-c C-k") (kbd "C-<SPC> M-> C-w")); kill until end of file
(define-key my-keys-minor-mode-map (kbd "C-c C-q") 'auto-fill-mode)
(define-key my-keys-minor-mode-map (kbd "C-c C-n") 'linum-mode)

(define-key my-keys-minor-mode-map (kbd "M-o") 'open-next-line)
(define-key my-keys-minor-mode-map (kbd "C-o") 'open-previous-line)
(define-key my-keys-minor-mode-map (kbd "C-=") 'make-main-header)
(define-key my-keys-minor-mode-map (kbd "C--") 'make-side-header)
(define-key my-keys-minor-mode-map (kbd "C-c l") 'nil)
(define-key my-keys-minor-mode-map (kbd "C-c n") 'nil)
(define-key my-keys-minor-mode-map (kbd "C-c j") 'nil)


(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings aren't overwritten."
  t " my-keys" 'my-keys-minor-mode-map)
(define-minor-mode my-tab-minor-mode
  "A minor mode so that my key settings aren't overwritten."
  t " autotab" 'my-tab-minor-mode-map)


(my-keys-minor-mode 1)
(my-tab-minor-mode 1)
(defun no-tab-hook ()
  (my-tab-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'no-tab-hook)
(add-hook 'term-mode-hook 'no-tab-hook)
(add-hook 'org-mode-hook 'no-tab-hook)
(add-hook 'geiser-repl-mode-hook 'no-tab-hook)
(add-hook 'cider-repl-mode-hook 'no-tab-hook)

;; org mode


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

(global-set-key (kbd "C-c +") 'increment-number-at-point)
(global-set-key (kbd "C-c -") 'decrement-number-at-point)

(defun w3mext-open-link-or-image-or-url ()
  "Opens the current link or image or current page's uri or any url-like text under cursor in firefox."
  (interactive)
  (let (url)
    (if (string= major-mode "w3m-mode")
        (setq url (or (w3m-anchor) (w3m-image) w3m-current-url)))
    (browse-url-generic (if url url (car (browse-url-interactive-arg "URL: "))))
    ))

(global-set-key (kbd "C-c b") 'w3mext-open-link-or-image-or-url)

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

(global-set-key (kbd "C-x C-n") 'nuke-file)

;; drop commands
(unbind-key "C-x C-z") ;; no more accidentally shrinking windows

;; todo: figure out filter 
(defun real-buffers (buffers)
    (cond ((null buffers) buffers)
          ((real-buffer (buffer-name (car buffers))) (cons (car buffers) (real-buffers (cdr buffers))))
          (t (real-buffers (cdr buffers)))))

(defun real-buffer (buffer) (not (or (string-prefix-p " *" buffer)
                                     (string-prefix-p "*" buffer))))

(bind-key* "C-S-s" (lambda ()
                     (interactive)
                     (multi-occur
                      (real-buffers (buffer-list))
                      (car (occur-read-primary-args)))))

;(bind-key* "M-S-s" (lambda () (interactive) (ag)))
