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
        '("code"
          "commands"
          "display"
          "extensions"
          "font"
          "localization"
          "misc-languages"
          "my-clojure"
          "my-go"
          "my-lisp"
          "my-org-mode"
          "my-python"
          "my-shell"
          ))

(server-start) ; let terminals open frames in main emacs session
(load "realgud") ; this has something to do with deubggers

(let ((scratch-file "~/quotes/quotes.el"))
  (if (file-exists-p scratch-file)
      (load-file scratch-file)
    (setq initial-scratch-message
          ";; A novice was trying to fix a broken Lisp machine by turning the
;; power off and on.

;; Knight, seeing what the student was doing, spoke sternly: 'You
;; cannot fix a machine by just power-cycling it with no
;; understanding of what is going wrong.'  Knight turned the machine
;; off and on.  The machine worked.

")))


(if blank-startup-screen
    (setq initial-scratch-message "")
    (let ((todo-file "~/todo/today.org"))
      (if (file-exists-p todo-file)
          (progn
            (split-window-below)
            (select-next-window)
            (find-file "~/todo/today.org")
            (org-shifttab 2)))
      )
    )
