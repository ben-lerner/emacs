;; Is this slow? Run benchmark-init.el.

(setq blank-startup-screen nil)

; package repos
(require 'package)
 (setq package-archives
       '(("marmalade" . "https://marmalade-repo.org/packages/")
         ("gnu" . "http://elpa.gnu.org/packages/")
         ("melpa" . "http://melpa.org/packages/")
         ("org" . "http://orgmode.org/elpa/")))

(add-to-list 'load-path "~/.emacs.d/elpa/")
(add-to-list 'load-path "~/emacs/packages/")
(package-initialize)

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
          "my-lisp"
          "my-org-mode"
          "my-python"
          "my-shell"
          "navigation"
          "quotes"
          ))

(server-start) ; let terminals open frames in main emacs session
(load "realgud") ; this has something to do with deubggers
