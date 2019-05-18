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

(bind-key* "C-SPC" 'my-dabbrev-expand)

;; minor mode
(defvar nav-minor-mode-map (make-keymap) "nav-minor-mode keymap")

(define-minor-mode nav-minor-mode
  "Turn off M-n and M-p for navigation in terminals and repls."
  t " nav" 'nav-minor-mode-map  ;; TODO: what is "t"?
  ;; Can I do this without a minor mode?
  )

(nav-minor-mode 1)

(defun no-nav-hook () (nav-minor-mode 0))

(add-hook 'term-mode-hook 'no-nav-hook)
(add-hook 'geiser-repl-mode-hook 'no-nav-hook)
(add-hook 'cider-repl-mode-hook 'no-nav-hook)
(add-hook 'org-mode-hook 'no-nav-hook)

;;;; navigate by paragraphs, but not in terminal mode
(bind-key "M-n" 'forward-paragraph nav-minor-mode-map)
(bind-key "M-p" 'backward-paragraph nav-minor-mode-map)
