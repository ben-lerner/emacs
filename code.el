;;; program mode hooks
(add-hook 'prog-mode-hook
          '(lambda ()
             (local-set-key (kbd "RET") 'newline-and-indent)
             (auto-fill-mode)
             (show-paren-mode)
             (rainbow-delimiters-mode)
             (display-line-numbers-mode)
             (set-fringe-style '(0 . nil))  ;; compensate for how wide display-line-numbers-mode is
             ))
(add-hook 'prog-mode-hook 'auto-fill-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

; web mode
(use-package web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js.?\\'" . javascript-mode))

(setq web-mode-engines-alist '(("jinja2" . "\\.jhtml\\'")))

;; text
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'rainbow-delimiters-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

(setq-default fill-column 80)
(setq TeX-PDF-mode t)

;; general
(add-hook 'before-save-hook
          '(lambda ()
             (if (derived-mode-p 'prog-mode)
                 (delete-trailing-whitespace))))
