;; paredit

(add-hook 'scheme-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(global-set-key (kbd "C-c C-p") 'paredit-mode)


;; scheme/racket
;; install mit-scheme:
;; run the .dmg, then run in command line:
;; sudo ln -s /Applications/MIT\:GNU\ Scheme.app/Contents/Resources /usr/local/lib/mit-scheme-x86-64; ln -s /usr/local/lib/mit-scheme-x86-64/mit-scheme /usr/local/bin/scheme


(setq scheme-program-name "scheme")
(setq geiser-active-implementations '(mit))
(setq geiser-repl-startup-time 10000)
(setq geiser-racket-binary "/Applications/Racket v6.0/bin/racket")
(setq geiser-guile-binary "/usr/local/bin/scheme")
(use-package xscheme)

;; (add-hook 'scheme-mode-hook '(lambda () (local-set-key 
;; 									 (kbd "C-<return>")
;; 									 (kbd "C-3"))))

;; clojure

;; things installed locally:
;; lein-exec for scripting

; for mccarthy annotations
;; (font-lock-add-keywords 'clojure-mode
;;   '(("\\<\\(caar\\|car\\|cdr\\|cadr\\|caddr\\|caar\\/cadar\\|cadar\\|caddar\\)\\>" . font-lock-keyword-face)))




;; fix the PATH variable
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")

(defun my-comment-sexp ()
  "comment sexp at point"
  (interactive)
  (comment-region (point) (save-excursion
			    (forward-sexp)
			    (point))))


(defun my-uncomment-line ()
  (uncomment-region (line-beginning-position) (line-end-position)))

(use-package thingatpt)
(defun sexp-at-point-p (pos)
  (save-excursion
    (goto-char pos)
    ;; or call (sexp-at-point) which is in thingatpt.el
    (condition-case nil
	(progn (forward-sexp)
	       t)
      (error nil))))

(defun my-uncomment-sexp ()
  "uncommon sexp at point"
  (interactive)
  (let* ((beg (line-beginning-position))
	 (end (save-excursion
		(comment-forward (point-max))
		(point))))
    (save-restriction
      (narrow-to-region beg end)
      (my-uncomment-line)
      (while (not (sexp-at-point-p beg))
	(forward-line 1)
	(my-uncomment-line))
      (goto-char beg))))
  
(defun my-toggle-comment-sexp ()
  (interactive)
  (let ((beg (line-beginning-position))
	(end (line-end-position)))
    (funcall (if (save-excursion ;; check for already commented region
		   (goto-char beg)
		   (comment-forward (point-max))
		   (<= end (point)))
		 'my-uncomment-sexp 'my-comment-sexp))))

(global-set-key (kbd "C-M-;") 'my-toggle-comment-sexp) ; comment/uncomment sexp
; from http://www.emacswiki.org/emacs/UncommentSexp

;; mega paredit
(defun paredit-barf-all-the-way-backward ()
    (interactive)
    (paredit-split-sexp)
    (paredit-backward-down)
    (paredit-splice-sexp))

 (defun paredit-barf-all-the-way-forward ()
    (interactive)
    (paredit-split-sexp)
    (paredit-forward-down)
    (paredit-splice-sexp)
    (if (eolp) (delete-horizontal-space)))

(defun paredit-slurp-all-the-way-backward ()
    (interactive)
    (catch 'done
      (while (not (bobp))
        (save-excursion
          (paredit-backward-up)
          (if (eq (char-before) ?\()
              (throw 'done t)))
        (paredit-backward-slurp-sexp))))

(defun paredit-slurp-all-the-way-forward ()
    (interactive)
    (catch 'done
      (while (not (eobp))
        (save-excursion
          (paredit-forward-up)
          (if (eq (char-after) ?\))
              (throw 'done t)))
        (paredit-forward-slurp-sexp))))



;; error on startup?

;; (nconc paredit-commands
;;          '("Extreme Barfage & Slurpage"
;;            (("C-M-)")
;;                         paredit-slurp-all-the-way-forward
;;                         ("(foo (bar |baz) quux zot)"
;;                          "(foo (bar |baz quux zot))")
;;                         ("(a b ((c| d)) e f)"
;;                          "(a b ((c| d)) e f)"))
;;            (("C-M-}" "M-F")
;;                         paredit-barf-all-the-way-forward
;;                         ("(foo (bar |baz quux) zot)"
;;                          "(foo (bar|) baz quux zot)"))
;;            (("C-M-(")
;;                         paredit-slurp-all-the-way-backward
;;                         ("(foo bar (baz| quux) zot)"
;;                          "((foo bar baz| quux) zot)")
;;                         ("(a b ((c| d)) e f)"
;;                          "(a b ((c| d)) e f)"))
;;            (("C-M-{" "M-B")
;;                         paredit-barf-all-the-way-backward
;;                         ("(foo (bar baz |quux) zot)"
;;                          "(foo bar baz (|quux) zot)"))))

;;   (paredit-define-keys)
;;   (paredit-annotate-mode-with-examples)
;;   (paredit-annotate-functions-with-examples)
