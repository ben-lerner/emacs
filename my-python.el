;; autoformatting
(use-package python-black
  :demand t
  :after python)

(add-hook 'python-mode-hook 'python-black-on-save-mode)
(remove-hook 'python-mode 'flycheck-mode)

;; autocomplete and refactoring
(use-package lsp-mode
  :hook
  ((python-mode . lsp)))

;; (use-package lsp-jedi
;;   :ensure t
;;   :config
;;   (with-eval-after-load "lps-mode"
;;     (add-to-list 'lsp-disabled-clients 'pyls)
;;     (add-to-list 'lsp-enabled-clients 'jedi)))

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp))))

(use-package elpy
  :bind (:map elpy-mode-map
              ("C-c C-t" . nil)))

(setq lsp-headerline-breadcrumb-enable nil)  ;; disable breadcrumb at the top
(setq lsp-completion-provider :none)         ;; disable stupid autocomplete pop-up

;; repl
(setq python-shell-interpreter-args "--simple-prompt -i")
(bind-key "C-p" 'comint-previous-matching-input-from-input inferior-python-mode-map)
(bind-key "C-n" 'comint-next-matching-input-from-input inferior-python-mode-map)
(bind-key "C-c C-c" 'python-shell-send-buffer python-mode-map)

;; testing
(require 'ansi-color)
(defun my/ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer)

(defun python-test ()
    ;; run pytype. If that passes, run unit tests.
    (interactive)
    (save-buffer)
    (compile "pytype . && python3 -m unittest discover"))

(bind-key "C-c C-t" 'python-test python-mode-map)

;; some autocomplete
(bind-key "C-c m"
          (lambda ()
            (interactive)
            (insert "if __name__ == '__main__':
    ")
            python-mode-map))

;; debugger
(add-hook 'python-mode-hook
		  (lambda () (highlight-lines-matching-regexp
                 "^[ ]*import i?pdb; i?pdb.set_trace()")))

(defun python-add-breakpoint ()
  (interactive)
  (open-previous-line 1)
  (insert "import ipdb; ipdb.set_trace()")
  (forward-char)
  (highlight-lines-matching-regexp "^[ ]*import ipdb")
  (highlight-lines-matching-regexp "^[ ]*ipdb.set_trace()"))

(bind-key "C-c C-b" 'python-add-breakpoint python-mode-map)

(elpy-enable)



(setq python-shell-interpreter "ipython3"
      python-shell-completion-native-enable nil
      python-shell-interpreter-args "-c exec('__import(\\'readline\\')') -i)"
      elpy-shell-echo-output 't)
