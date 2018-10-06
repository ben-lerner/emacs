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
          ; (cider-repl-set-ns) ;; todo: fix this
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
(bind-key "C-`" 'cider-jump-to-compilation-error cider-stacktrace-mode-map)

;; navigation
(require 'subr-x) ;; string functions

(defun clj-file-prefix ()
  "Get the standard file prefix from either source or test."
  (string-remove-suffix
   "_test"
   (file-name-sans-extension buffer-file-name)))

(defun goto-clj-source ()
  (interactive)
  (find-file
   (concat
    (replace-regexp-in-string "/test/" "/src/" (clj-file-prefix))
    "."
    (file-name-extension buffer-file-name))))

(defun goto-clj-test ()
  (interactive)
  (find-file
   (concat
    (replace-regexp-in-string "/src/" "/test/" (clj-file-prefix))
    "_test."
    (file-name-extension buffer-file-name))))

(bind-key "M-g s" 'goto-clj-source clojure-mode-map)
(bind-key "M-g t" 'goto-clj-test clojure-mode-map)

;; more cider
(setq cider-default-cljs-repl 'figwheel-main)

(defun goto-repl ()
  (interactive)
  (with-existing-window
   (cider-jack-in-clj&cljs)))

(bind-key* "M-g M-r" 'goto-repl)

;; clojurescript
;; (setq cider-cljs-lein-repl
;;       ;; automatically start figwheel when running cider-jack-in-clojurescript
;;       ;; from markhudnall.com/2016/04/25/starting-figwheel-in-emacs/
;;       "(do (require 'figwheel-sidecar.repl-api)
;;            (figwheel-sidecar.repl-api/start-figwheel!)
;;            (figwheel-sidecar.repl-api/cljs-repl))")
