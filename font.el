(when (window-system)
  (on-mac
   (set-default-font "Fira Code-14")
   (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol")

   (let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
                  (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
                  (36 . ".\\(?:>\\)")
                  (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
                  (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
                  (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
                  (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
                  (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
                  ;; (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)") ;; breaks cider
                  (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
                  (48 . ".\\(?:x[a-zA-Z]\\)")
                  (58 . ".\\(?:::\\|[:=]\\)")
                  (59 . ".\\(?:;;\\|;\\)")
                  (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
                  (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
                  (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
                  (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
                  (91 . ".\\(?:]\\)")
                  (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
                  (94 . ".\\(?:=\\)")
                  (119 . ".\\(?:ww\\)")
                  (123 . ".\\(?:-\\)")
                  (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
                  (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
                  )
                ))
     (dolist (char-regexp alist)
       (set-char-table-range composition-function-table (car char-regexp)
                             `([,(cdr char-regexp) 0 font-shape-gstring])))))
  
  (on-linux (set-default-font "Fira Code-12")))

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
     ; ("((x))" . ?⊗)
     ))
  
  (on-linux
   (add-symbols
    '(("<=" . ?≤)
      (">=" . ?≥)
      ("!=" . ?≠)
      ("->" . ?⇾)  ; U+21FE
      ("<-" . ?⇽)
      ("==>" . ?⇒)
      ("<==" . ?⇐)))))

; all modes; for some reason fundamental-mode-hook doesn't work

(global-prettify-symbols-mode 1)

;; todo: does this need to be a hook?
(add-hook 'prog-mode-hook 'set-pretty-symbols)
(add-hook 'term-mode-hook 'set-pretty-symbols)
(add-hook 'org-mode-hook 'set-pretty-symbols)
(add-hook 'c-mode-common-hook 'set-pretty-symbols)

(add-hook 'emacs-lisp-mode-hook ;; display quotes properly
		  (lambda ()
			(if (string= (buffer-name) "*scratch*")
				(prettify-symbols-mode 0))))

(add-hook 'web-mode-hook (lambda () (prettify-symbols-mode 0)))
