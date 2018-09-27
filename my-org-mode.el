(require 'org-bullets)

;; todo: move to bind-key
(add-hook 'org-mode-hook (lambda ()
						   (rainbow-delimiters-mode -1)
                           (org-bullets-mode 1)

;                           (linum-mode)
                           ;; disable changes in org-mode level heights
                           ;; (dolist (face '(org-level-1
                           ;;                 org-level-2
                           ;;                 org-level-3
                           ;;                 org-level-4
                           ;;                 org-level-5))
                           ;;   (set-face-attribute face nil :weight 'semi-bold :height 1.0))
))

(bind-key "<left>" 'org-do-promote org-mode-map)
(bind-key "<right>" 'org-do-demote org-mode-map)
(bind-key "C-M-`" 'org-shifttab org-mode-map)
(bind-key "M-<left>" 'org-promote-subtree org-mode-map)
(bind-key "M-<right>" 'org-demote-subtree org-mode-map)
(bind-key "M-n" (kbd "M-5 C-n") org-mode-map)
(bind-key "M-p" (kbd "M-5 C-p") org-mode-map)
(bind-key "<return>" 'org-meta-return org-mode-map)
(bind-key "M-i" 'org-cycle org-mode-map)

(setq org-log-done 'time)
(setq org-ellipsis " ⤵")

(defun my-filter (pred seq)
  (if (= 0 (length seq))
      nil
    (if (funcall pred (car seq))
        (cons (car seq) (my-filter pred (cdr seq)))
      (my-filter pred (cdr seq)))))

(bind-key* "C-c c" 'org-capture)

(setq todo-dir "~/todo/")

;; all directories in todo-dir except for "..", ".", "archive", and "notes"
(setq org-agenda-files
      (list todo-dir))

(setq org-default-notes-file (concat todo-dir "todo.org"))
(setq org-capture-templates
      '(("i" "Inbox" entry (file+headline org-default-notes-file "Inbox")
         "* %?")
        ("e" "emacs" entry (file+headline (concat todo-dir "emacs.org") "To do")
         "* %?")
        ("c" "Code" entry (file+headline org-default-notes-file "Code")
         "* TODO %? \n %f")
        ("l" "Lookup" entry (file+headline org-default-notes-file "Look Up")
         "* %?")
        ("t" "To do" entry (file+headline org-default-notes-file "Inbox")
         "* TODO %? \n %f")
        ("a" "Article" entry (file+headline org-default-notes-file "Article")
         "* %?")
        ("b" "Book" entry (file+headline (concat todo-dir "books.org") "Inbox")
         "* %?")))

(defun goto-todo-file (file)
  (find-file (concat todo-dir file ".org")))

(defun goto-log ()
  (interactive)
  (goto-todo-file "log"))

(defun goto-todo ()
  (interactive)
  (goto-todo-file "todo"))

(defun goto-archive ()
  (interactive)
  (goto-todo-file "archive"))


;; todo: figure out how this works, add more words
(setq org-todo-keyword-faces
           '(("TODO" . org-warning) ("STARTED" . "yellow")
             ("CANCELED" . (:foreground "blue" :weight bold))))

(defun note-file ()
  (concat "~/todo/notes/"  (todays-date) ".txt"))

(defun goto-note () ; find today's note
    (interactive)
    (find-file (note-file)))

(defun constant-height ()
  "Prevent themes from changing header sizes."
  (dolist (face '(org-level-1
                  org-level-2
                  org-level-3
                  org-level-4
                  org-level-5))
    (set-face-attribute face nil :weight 'semi-bold :height 1.0)))

(add-hook 'org-mode-hook 'constant-height)

;; custom tab behavior

(defun org-tab ()
  "Indent at the start of a line, autocomplete otherwise."
  (interactive)
  (if (string-match-p "^*+ +$" (thing-at-point 'line t))
      (org-do-demote)
      (my-dabbrev-expand)))

(bind-key "<tab>" 'org-tab org-mode-map)

(bind-key "<backtab>" 'org-do-promote org-mode-map)
(bind-key "<S-tab>" 'org-do-promote org-mode-map)
(bind-key "<S-iso-lefttab>" 'org-do-promote org-mode-map)
