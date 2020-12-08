(defun term-dabbrev-expand ()
  (let ((beg (point)))
    (dabbrev-expand nil)
    (kill-region beg (point)))
  (term-send-raw-string (substring-no-properties (current-kill 0))))

(defun line-at-point ()
  ;; get current line, up to where point is
  (substring (thing-at-point 'line 't) 0 (current-column)))

(defun my-dabbrev-expand ()
  (interactive)
  (cond
   ;; no autocomplete at start of line
   ;; "start" includes whitespace and, for org-mode-, asterisks
   ((string-match "^ *\\** *$" (line-at-point))
    (if (string= major-mode "org-mode")
        (org-do-demote)
        (indent-for-tab-command)))
   (t (dabbrev-expand nil))))

(setq dabbrev-case-fold-search nil)

;; minor mode
(defvar my-tab-minor-mode-map (make-keymap) "my-tab-minor-mode keymap")

(define-minor-mode my-tab-minor-mode
  "<tab> calls dabbrev-expand. Not used in repls, terminals, etc."
  t " autotab" 'my-tab-minor-mode-map)

(my-tab-minor-mode 1)

;; default keybinding
(bind-key* "C-<tab>" 'my-dabbrev-expand)

;; for modes without existing tab functionality
(bind-key "C-<tab>" 'indent-for-tab-command my-tab-minor-mode-map)
(bind-key "TAB" 'my-dabbrev-expand my-tab-minor-mode-map)

(defun no-tab-hook () (my-tab-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'no-tab-hook)
(add-hook 'vterm-mode-hook 'no-tab-hook)
(add-hook 'geiser-repl-mode-hook 'no-tab-hook)
(add-hook 'cider-repl-mode-hook 'no-tab-hook)

;;;; navigate by paragraphs, but not in terminal mode
(bind-key "M-n" 'forward-paragraph my-tab-minor-mode-map)
(bind-key "M-p" 'backward-paragraph my-tab-minor-mode-map)
