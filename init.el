;; Set .emacs to (load "~/emacs/init.el")

;; Is this slow? Run benchmark-init.el.
(setq blank-startup-screen nil)

; package repos
(require 'package)
(setq package-archives
      '(; ("marmalade" . "https://marmalade-repo.org/packages/")  ;; cert expired
        ("gnu" . "https://elpa.gnu.org/packages/")  ;; currently down?
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/elpa/")
(add-to-list 'load-path "~/emacs/packages/")

(setq byte-compile-warnings '(cl-functions))

; load files
(mapcar (lambda (name) (load-file (concat "~/emacs/" name ".el")))
        '("elisp-utils" ;; run this first
          "code"
          "commands"
          "display"
          "extensions"
          "font"
          "localization"
;          "misc-languages" ;; speed up startup
          "my-c"
          "my-clojure"
;          "my-go" ;; speed up startup
          "my-latex"
          "my-lisp"
          "my-org-mode"
          "my-python"
          "my-shell"
          "navigation"
          "quotes"
          "source-control"
          "tab-autocomplete"
          ))

(cd "~")
(load "realgud") ; this has something to do with deubggers
