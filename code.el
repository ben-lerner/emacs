;;; program mode hooks
(add-hook 'prog-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))
(add-hook 'prog-mode-hook 'auto-fill-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'hs-minor-mode) ;; code collapsing, don't really use this
(add-hook 'prog-mode-hook '(lambda () (local-set-key (kbd "C-;") 'hs-toggle-hiding)))
(add-hook 'prog-mode-hook 'linum-mode)

;; c/c++
;; c comments
(add-hook 'c-mode-hook (lambda () (setq comment-start "// " comment-end   "")))
(add-hook 'c++-mode-hook (lambda () (setq comment-start "// " comment-end   "")))

(defun my-c-mode-insert-lcurly () ; autocomplete ;
  (interactive)
  (insert "{")
  (let ((pps (syntax-ppss)))
    (when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
      (c-indent-line)
      (insert "\n\n}")
      (c-indent-line)
      (forward-line -1)
      (c-indent-line))))

(add-hook 'c-mode-common-hook (lambda () (local-set-key "{" 'my-c-mode-insert-lcurly)))

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

;; bash
(setq explicit-bash-args '("--login" "--init-file" "~/Dropbox/bash_profile" "-i"))
(global-set-key (kbd "C-M-'") (kbd "C-u M-x shell <RET>"))
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
