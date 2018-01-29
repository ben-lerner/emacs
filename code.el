;;; program mode hooks
(add-hook 'prog-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))
(add-hook 'prog-mode-hook 'auto-fill-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'linum-mode)

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
