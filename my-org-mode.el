(require 'org-bullets)

(add-hook 'org-mode-hook (lambda ()
						   (local-set-key (kbd "C-<left>") 'org-do-promote)
						   (local-set-key (kbd "C-<right>") 'org-do-demote)
						   (local-set-key (kbd "M-<left>") 'org-promote-subtree)
						   (local-set-key (kbd "M-<right>") 'org-demote-subtree)
						   (local-set-key (kbd "M-n") (kbd "M-5 C-n"))
						   (local-set-key (kbd "M-p") (kbd "M-5 C-p"))
						   (local-set-key (kbd "<return>") 'org-meta-return)
                           (local-set-key (kbd "<S-return>") 'org-return)
						   (local-set-key (kbd "M-<return>") (kbd "<return> C-<right>"))
						   (local-set-key (kbd "C-<return>") (kbd "<return> C-<left>"))
;                           (linum-mode)
						   (rainbow-delimiters-mode -1)
                           (org-bullets-mode 1)
                           ;; disable changes in org-mode level heights
                           ;; (dolist (face '(org-level-1
                           ;;                 org-level-2
                           ;;                 org-level-3
                           ;;                 org-level-4
                           ;;                 org-level-5))
                           ;;   (set-face-attribute face nil :weight 'semi-bold :height 1.0))
))

(setq org-log-done 'time)
(setq org-ellipsis " ⤵")

(defun my-filter (pred seq)
  (if (= 0 (length seq))
      nil
    (if (funcall pred (car seq))
        (cons (car seq) (my-filter pred (cdr seq)))
      (my-filter pred (cdr seq)))))

(define-key global-map (kbd "C-c c") 'org-capture)

(let ((todo-dir "~/todo/"))
  (setq org-agenda-files (my-filter 'file-exists-p (list todo-dir)))
  (setq org-default-notes-file (concat todo-dir "todo.org"))
  (setq org-capture-templates
        '(("i" "Inbox" entry (file+headline org-default-notes-file "Inbox")
           "* %? \n %t")
          ("e" "emacs" entry (file+headline (concat todo-dir "emacs.org") "To do")
           "* %? \n %t")
          ("c" "Code" entry (file+headline org-default-notes-file "Code")
           "* TODO %? \n %t %f")
          ("l" "Lookup" entry (file+headline org-default-notes-file "Look Up")
           "* %? \n %t")
          ("t" "To do" entry (file+headline org-default-notes-file "Inbox")
           "* TODO %? \n %t %f")
          ("a" "Article" entry (file+headline org-default-notes-file "Article")
           "* %? \n %T")
          ("b" "Book" entry (file+headline (concat todo-dir "books.org") "Inbox")
           "* %?"))))

;; todo: figure out how this works, add more words
(setq org-todo-keyword-faces
           '(("TODO" . org-warning) ("STARTED" . "yellow")
             ("CANCELED" . (:foreground "blue" :weight bold))))
