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

(add-hook 'term-mode-hook 'goto-address-mode)

(bind-key* "M-'" 'multi-vterm)
(bind-key* "M-\"" 'multi-vterm-next)

;; ;; ;; don't intercept editing commands
;; (defun term-send-backward-kill-word ()
;;   "Backward kill word in term mode."
;;   (interactive)
;;   (term-send-raw-string "\C-w"))

;; (defun term-send-forward-kill-word ()
;;   "Kill word in term mode."
;;   (interactive)
;;   (term-send-raw-string "\ed"))

;; (defun term-send-backward-word ()
;;   "Move backward word in term mode."
;;   (interactive)
;;   (term-send-raw-string "\eb"))

;; (defun term-send-forward-word ()
;;   "Move forward word in term mode."
;;   (interactive)
;;   (term-send-raw-string "\ef"))

;; (bind-key "M-f" 'term-send-forward-word term-raw-map)
;; (bind-key "M-b" 'term-send-backward-word term-raw-map)
;; (bind-key "<M-backspace>" 'term-send-backward-kill-word term-raw-map)

;; ;; these get overwritten somehow
;; (add-hook 'term-mode-hook
;;           (lambda ()
;;             (bind-key "M-d" 'term-send-forward-kill-word term-raw-map)
;;             (bind-key "C-p" 'term-send-up term-raw-map)
;;             (bind-key "C-n" 'term-send-down term-raw-map)))
