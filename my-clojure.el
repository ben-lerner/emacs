(require 'clojure-mode)
(require 'cider-mode)

(add-hook 'clojure-mode-hook 'paredit-mode)

;; must eval buffer before lookup works
(bind-key "M-." 'cider-find-var cider-mode-map)
(unbind-key "M-?" paredit-mode-map)
(bind-key "M-?" 'cljr-find-usages cider-mode-map)
(setq cljr-warn-on-eval nil)

;; save; load buffer; set ns; switch to repl
(bind-key "C-c C-k"
          (lambda ()
            (interactive)
            (save-buffer)
            (cider-load-buffer-and-switch-to-repl-buffer t))
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
  (save-buffer)
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

(bind-key* "M-g M-r" 'cider-jack-in)

(use-package html-to-hiccup)
;; use html-to-hiccup-convert-region

(defun hiccupify ()
  (interactive)
  (html-to-hiccup-convert-region (region-beginning) (region-end))
  ;; fix comments from [:comment] syntax
  (while (re-search-forward "\\[:comment \" \\(.*?\\) \"\\]")
    (replace-match ";; \\1
")))


(add-hook 'cider-repl-mode-hook #'paredit-mode)
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)

(defun repl-exists? ()
  (cl-remove-if-not
   (lambda (haystack) (string-prefix-p "*nrepl-server" haystack))
   (mapcar #'buffer-name (buffer-list))))

(defun eval-clj-buffer ()
  (cider-load-buffer)
  (cider-repl-set-ns (cider-current-ns)))

(defun my-clj-file? ()
  ;; Checks if a file should be evaluated. Excludes read-only files and .jar
  ;; files; this is meant to avoid extra evals and prompts when using goto-def.
  (and (not buffer-read-only)
       (not (string-match-p "jar:" buffer-file-name))))

(defun autoeval-clj-file ()
  ;; Starts repl if one doesn't exist, then evalute the current file so goto-def
  ;; works. The file's evaluated through cider-connected-hook when starting a
  ;; new repl.
  ;; Skip read-only buffers (e.g. when browsing definitions.)
  (when (my-clj-file?)
    (if (repl-exists?)
        (eval-clj-buffer)
        (cider-jack-in-clj nil))))

;; automatically start cider, don't go to it
(setq cider-repl-pop-to-buffer-on-connect nil)
(add-hook 'clojure-mode-hook 'autoeval-clj-file)

(add-hook 'cider-connected-hook
          (lambda ()
            (cider-switch-to-last-clojure-buffer)
            (eval-clj-buffer)))

;; don't prompt for find-var symbol
(setq cider-prompt-for-symbol nil)

(require 'flycheck-clj-kondo)
(add-hook 'clojure-mode-hook 'flycheck-mode)
;; See instructions for building cache in new projects.
