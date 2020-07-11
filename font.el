(when (window-system)
  (set-default-font "Fira Code 12"))

(defun set-pretty-symbols ()
  (setq-local old-symbols-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist
              (append
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
                 ;; ("<=" . ?≤)
                 ;; (">=" . ?≥)
                 ;; ("!=" . ?≠)
                 ;; ("->" . ?⇾)  ; U+21FE
                 ;; ("<-" . ?⇽)
                 ;; ("<<-" . ?↞)
                 ;; ("->>" . ?↠)
                 )
               old-symbols-alist)))

(global-prettify-symbols-mode 1)

(defun fira-code-mode--make-alist (list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ #Xe100 idx))
          (width (string-width s))
          (prefix ())
          (suffix '(?\s (Br . Br)))
          (n 1))
     (while (< n width)
       (setq prefix (append prefix '(?\s (Br . Bl))))
       (setq n (1+ n)))
     (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst fira-code-mode--ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
    "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
    "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
    "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
    "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
    "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
    "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
    "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
    ":" "+" "+" "*"))

(defvar fira-code-mode--old-prettify-alist)

(defun fira-code-mode--enable ()
  "Enable Fira Code ligatures in current buffer."
  (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist
              (append (fira-code-mode--make-alist fira-code-mode--ligatures)
                      fira-code-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun fira-code-mode--disable ()
  "Disable Fira Code ligatures in current buffer."
  (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode fira-code-mode
  "Fira Code ligatures minor mode"
  :lighter " Fira Code"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if fira-code-mode
      (fira-code-mode--enable)
    (fira-code-mode--disable)))

(defun fira-code-mode--setup ()
  "Setup Fira Code Symbols"
  (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))

(provide 'fira-code-mode)
;; todo: does this need to be a hook?

(defun init-buffer ()
  "Initiliaze buffer."
  (set-pretty-symbols)
  (undo-tree-mode)
  (fira-code-mode))

(add-hook 'prog-mode-hook 'init-buffer)
(add-hook 'term-mode-hook 'init-buffer)
(add-hook 'c-mode-common-hook 'init-buffer)

(add-hook 'emacs-lisp-mode-hook ;; display quotes properly
		  (lambda ()
			(when (string= (buffer-name) "*scratch*")
              (display-line-numbers-mode 0)
              (fringe-mode nil)
              (paredit-mode 0))))

(add-hook 'web-mode-hook (lambda () (prettify-symbols-mode 0)))
