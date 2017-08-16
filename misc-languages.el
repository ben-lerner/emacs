;; rust
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook
          (lambda () (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;; ruby
(use-package flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; nsis/nsi mode
(autoload 'nsis-mode "nsis-mode" "NSIS mode" t)
(add-to-list 'auto-mode-alist '("\\.nsi\\'" . nsis-mode))

