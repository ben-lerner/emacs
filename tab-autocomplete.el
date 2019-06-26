;; dabbrev-expand for terminals
(defun term-dabbrev-expand ()
  (interactive)
  (let ((beg (point)))
    (dabbrev-expand nil)
    (kill-region beg (point)))
  (term-send-raw-string (substring-no-properties (current-kill 0))))

(defun my-dabbrev-expand ()
  (interactive)
  (if (= (current-column) 0)
      (indent-for-tab-command)  ;; no autocomplete at start of column
    (if (string= major-mode "term-mode")
        (term-dabbrev-expand)
      (dabbrev-expand nil))))

(setq dabbrev-case-fold-search nil)

;; minor mode
(defvar my-tab-minor-mode-map (make-keymap) "my-tab-minor-mode keymap")

(define-minor-mode my-tab-minor-mode
  "<tab> calls dabbrev-expand. Not used in repls, terminals, etc."
  t " autotab" 'my-tab-minor-mode-map)

(my-tab-minor-mode 1)

;; default keybinding
(global-set-key (kbd "C-<tab>") 'my-dabbrev-expand)

;; for modes without existing tab functionality
(bind-key "C-<tab>" 'indent-for-tab-command my-tab-minor-mode-map)
(bind-key "<tab>" 'my-dabbrev-expand my-tab-minor-mode-map)
(bind-key "M-`" 'my-dabbrev-expand)  ;; for ssh

(defun no-tab-hook () (my-tab-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'no-tab-hook)
(add-hook 'term-mode-hook 'no-tab-hook)
(add-hook 'geiser-repl-mode-hook 'no-tab-hook)
(add-hook 'cider-repl-mode-hook 'no-tab-hook)
(add-hook 'org-mode-hook 'no-tab-hook)

;;;; navigate by paragraphs, but not in terminal mode
(bind-key "M-n" 'forward-paragraph my-tab-minor-mode-map)
(bind-key "M-p" 'backward-paragraph my-tab-minor-mode-map)
