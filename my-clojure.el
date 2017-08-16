(require 'clojure-mode)
(require 'cider-mode)

(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook '(lambda () (local-set-key 
									 (kbd "C-<return>")
									 (kbd "C-x 2 C-x C-s C-c C-a"))))

(bind-key "C-c C-k"
          (lambda ()
            (interactive)
            (save-buffer)
            (cider-load-buffer))
          cider-mode-map)

;; must eval buffer before lookup works
(bind-key "C-." (kbd "C-c C-k M-.") clojure-mode-map)

;; save; load buffer; set ns; switch to repl
(bind-key "C-c k" (kbd "C-x C-s  C-c C-k  C-c M-n  C-c C-z") clojure-mode-map)

;; recommended by compojure
(define-clojure-indent
  (defroutes 'defun)
  (GET 2)
  (POST 2)
  (PUT 2)
  (DELETE 2)
  (HEAD 2)
  (ANY 2)
  (context 2))

; (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode) ;; todo: fixme

;; add this line to ~/.lein/profiles.clj:
;; {:user {:plugins [[cider/cider-nrepl "0.14.0"]]}}
