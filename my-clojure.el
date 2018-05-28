(require 'clojure-mode)
(require 'cider-mode)

(add-hook 'clojure-mode-hook 'paredit-mode)

;; must eval buffer before lookup works
(bind-key "C-."
          (lambda ()
            (interactive)
            (save-buffer)
            (cider-load-buffer)
            (cider-find-var))
          clojure-mode-map)

;; save; load buffer; set ns; switch to repl
(bind-key "C-c C-k"
          (lambda ()
            (interactive)
            (save-buffer)
            (cider-load-buffer)
;            (cider-repl-set-ns) ;; todo: fix this
            (cider-switch-to-repl-buffer))
          cider-mode-map)

(bind-key "C-c d" 'cider-debug-defun-at-point)

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

(setq-default cider-repl-display-help-banner nil)

; (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode) ;; todo: fixme

;; add this line to ~/.lein/profiles.clj:
;; {:user {:plugins [[cider/cider-nrepl "0.14.0"]]}}

;; cider
(bind-key "<up>" 'cider-repl-backward-input cider-repl-mode-map)
(bind-key "<down>" 'cider-repl-forward-input cider-repl-mode-map)
(bind-key "C-p" 'cider-repl-backward-input cider-repl-mode-map)
(bind-key "C-n" 'cider-repl-forward-input cider-repl-mode-map)
(setq cljr-suppress-middleware-warnings t)

;; auto-refresh cider
(bind-key "C-c C-r" 'cider-refresh clojure-mode-map)

(defun set-ns ()
  (interactive)
  (cider-switch-to-repl-buffer (cider-current-ns))
  (cider-refresh))

;; set namespace and goto-repl in one command
(bind-key "C-c C-n" 'set-ns clojure-mode-map)  ;; todo: experiment with clearing repl
