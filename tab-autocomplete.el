;; dabbrev-expand for terminals
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

(setq dabbrev-case-fold-search nil)

;; default keybinding
(bind-key* "M-`" 'my-dabbrev-expand)  ;; for ssh

;; minor mode
(defvar no-nav-minor-mode-map (make-keymap) "no-nav-minor-mode keymap")

(define-minor-mode nav-minor-mode
  "Turn off M-n and M-p for navigation in terminals and repls."
  t " autotab" 'nav-minor-mode-map  ;; TODO: what is this?
  ;; Can I do this without a minor mode?
  )

(no-nav-minor-mode 1)

(defun no-nav-hook () (no-nav-minor-mode 0))

(add-hook 'term-mode-hook 'no-nav-hook)
(add-hook 'geiser-repl-mode-hook 'no-nav-hook)
(add-hook 'cider-repl-mode-hook 'no-nav-hook)
(add-hook 'org-mode-hook 'no-nav-hook)

;;;; navigate by paragraphs, but not in terminal mode
(bind-key "M-n" 'forward-paragraph no-nav-minor-mode-map)
(bind-key "M-p" 'backward-paragraph no-nav-minor-mode-map)
