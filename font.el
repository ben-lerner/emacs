(when (window-system)
  (set-default-font "Hack 14"))

(defun set-pretty-symbols ()
  (setq prettify-symbols-alist '())
  (defun add-symbols (list)
    (mapcar
     (lambda (text-symbol-pair)
       (push text-symbol-pair prettify-symbols-alist))
     list))
  (add-symbols
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
     ;; ("((x))" . ?⊗)
     ("<=" . ?≤)
     (">=" . ?≥)
     ("!=" . ?≠)
     ("->" . ?⇾)  ; U+21FE
     ("<-" . ?⇽)
     ("<<-" . ?↞)
     ("->>" . ?↠))
     ))

(global-prettify-symbols-mode 1)

;; todo: does this need to be a hook?
(add-hook 'prog-mode-hook 'set-pretty-symbols)
(add-hook 'term-mode-hook 'set-pretty-symbols)
(add-hook 'org-mode-hook 'set-pretty-symbols)
(add-hook 'c-mode-common-hook 'set-pretty-symbols)

(add-hook 'emacs-lisp-mode-hook ;; display quotes properly
		  (lambda ()
			(when (string= (buffer-name) "*scratch*")
              (display-line-numbers-mode 0)
              (fringe-mode nil)
              (prettify-symbols-mode 0)
              (paredit-mode 0))))

(add-hook 'web-mode-hook (lambda () (prettify-symbols-mode 0)))
