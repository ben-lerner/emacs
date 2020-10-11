(add-to-list 'default-frame-alist
             '(font . "Hack-13"))

(defun set-pretty-symbols ()
  (setq-local prettify-symbols-alist
        '(("alpha" . ?α)
          ("beta" . ?β)
          ("gamma" . ?γ)
          ("delta" . ?δ)
          ("epsilon" . ?ε)
          ("eta" . ?η)
          ("theta" . ?θ)
          ("lambda" . ?λ)
          ("mu" . ?μ)
          ("rho" . ?ρ)
          ("phi" . ?φ)
          ("pi" . ?π)
          ("partial" . ?∂)
          ("<=" . ?≤)
          (">=" . ?≥)
          ("!=" . ?≠))))

(global-prettify-symbols-mode 1)

(add-hook 'prog-mode-hook 'set-pretty-symbols)
(add-hook 'term-mode-hook 'set-pretty-symbols)
(add-hook 'c-mode-common-hook 'set-pretty-symbols)

(add-hook 'emacs-lisp-mode-hook ;; display quotes properly
		  (lambda ()
			(when (string= (buffer-name) "*scratch*")
              (display-line-numbers-mode 0)
              (fringe-mode nil)
              (paredit-mode 0))))

(add-hook 'web-mode-hook (lambda () (prettify-symbols-mode 0)))
