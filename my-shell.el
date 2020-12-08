(use-package vterm)
(use-package multi-vterm)

;; todo: move all shell code here

;; get shell-command (M-!) to execute bash profile
(setq shell-file-name "bash")

(on-mac
 (setq shell-command-switch "-ic"))

(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

(defun term-toggle-mode ()
  "Toggles term between line mode and char mode"
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

(add-hook 'cterm-mode-hook 'goto-address-mode)

(bind-key* "M-'" 'multi-vterm)
(bind-key* "M-\"" 'multi-vterm-next)
