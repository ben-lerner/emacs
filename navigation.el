;; buffer navigation
(require 'ace-jump-mode)
(require 'ace-window)

(bind-key* "C-c SPC" 'ace-jump-mode)

(bind-key* "M-n" 'forward-paragraph)
(bind-key* "M-p" 'backward-paragraph)

;;;; find the next/previous instance of token under cursor
(require 'evil)

(bind-key* "M-N" 'evil-search-word-forward)
(bind-key* "M-P" 'evil-search-word-backward)

(defun zap-up-to-char (arg char)
  "Kill up to, but not including ARGth occurrence of CHAR.
   Case is ignored if `case-fold-search' is non-nil in the current buffer.
   Goes backward if ARG is negative; error if CHAR not found.
   Ignores CHAR at point."
   (interactive "p\ncZap up to char: ")
   (let ((direction (if (>= arg 0) 1 -1)))
     (kill-region (point)
                  (progn
                    (forward-char direction)
                    (unwind-protect
                        (search-forward (char-to-string char) nil nil arg)
                      (backward-char direction))
                    (point)))))

(defun zap-past-char (arg char)
  "Kill up to and including ARGth occurrence of CHAR. "
   (interactive "p\ncZap past char: ")
   (let ((direction (if (>= arg 0) 1 -1)))
     (kill-region (point)
                  (progn
                    (forward-char direction)
                    (unwind-protect
                        (search-forward (char-to-string char) nil nil arg))
                    (point)))))

(defun go-to-char (arg char)
  "Analagous to zap, but just moves."
  (interactive "p\ncMove up to char: ")
  (let ((direction (if (>= arg 0) 1 -1)))
    (forward-char direction) ;; move to next char if you're already on an instance
    (search-forward (char-to-string char) nil nil arg)
    (backward-char direction)))

(defun open-next-line (arg)
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

(defun open-previous-line (arg)
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

(bind-key* "M-o" 'open-next-line)
(bind-key* "C-o" 'open-previous-line)


;;;; scroll by half page
(defun zz-scroll-half-page (direction)
  "Scrolls half page up if `direction' is non-nil, otherwise will scroll half page down."
  (let ((opos (cdr (nth 6 (posn-at-point)))))
    ;; opos = original position line relative to window
    (move-to-window-line nil)  ;; Move cursor to middle line
    (if direction
        (recenter-top-bottom -1)  ;; Current line becomes last
      (recenter-top-bottom 0))  ;; Current line becomes first
    (move-to-window-line opos)))  ;; Restore cursor/point position

(defun zz-scroll-half-page-down ()
  "Scrolls exactly half page down keeping cursor/point position."
  (interactive)
  (zz-scroll-half-page nil))

(defun zz-scroll-half-page-up ()
  "Scrolls exactly half page up keeping cursor/point position."
  (interactive)
  (zz-scroll-half-page t))

(bind-key* "C-v" 'zz-scroll-half-page-down)
(bind-key* "M-v" 'zz-scroll-half-page-up)

;; between-buffer navigation
(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings)
  (setq windmove-wrap-around t))

(bind-key* "C-u" 'select-next-window)
(bind-key* "M-u" 'select-previous-window)
(bind-key* "C-]" 'ace-window)
(use-package transpose-frame)

(bind-key* "C-x t" 'rotate-frame) ; 'transpose'


;; file navigation

(defun ffap-with-line ()
  "Opens the file at point and goes to line-number."
  (interactive)
  (let ((fname (ffap-file-at-point)))
    (if fname
      (let ((line
             (save-excursion
               (goto-char (cadr ffap-string-at-point-region))
               (and (re-search-backward ":\\([0-9]+\\)"
                                        (line-beginning-position) t)
                    (string-to-number (match-string 1))))))
        ;; (message "file:%s,line:%s" fname line)
        (when (and (tramp-tramp-file-p default-directory)
                   (= ?/ (aref fname 0)))
          ;; if fname is an absolute path in remote machine, it will not return a tramp path,fix it here.
          (let ((pos (position ?: default-directory)))
            (if (not pos) (error "failed find first tramp indentifier ':'"))
            (setf pos (position ?: default-directory :start (1+ pos)))
            (if (not pos) (error "failed find second tramp indentifier ':'"))
            (setf fname (concat (substring default-directory 0 (1+ pos)) fname))))
        (message "fname:%s" fname)
        (find-file-existing fname)
        (when line (goto-line line)))
      (error "File does not exist."))))

(bind-key* "M-g M-n" 'goto-note)
(bind-key* "M-g M-l" 'goto-log)
(bind-key* "M-g M-q" 'goto-quotes)
(bind-key* "M-g M-t" 'goto-todo)
(bind-key* "M-g M-f" 'ffap-with-line)
(bind-key* "M-g M-b" 'browse-url-of-file)

;; file autocomplete
(helm-mode 1)

(setq helm-ff-skip-boring-files 't)
(setq helm-ff-skip-git-ignored-files 't)

(bind-key* "C-x C-f" 'helm-find-files)
(bind-key* "M-x" 'helm-M-x)
(bind-key* "C-x b" 'helm-buffers-list)
(bind-key "<tab>" 'helm-ff-RET helm-map)

;; todo: refactor
;; headers assume .cc
(defun test-file ()
  (let ((filename (buffer-file-name)))
    (cond ((string-match "_test\\." filename) ;; test file
           filename)
          ((string-match "\\.h" filename) ;; header file
           (replace-regexp-in-string "\\.h" "_test.cc" filename))
          (t  ;; source file
           (replace-regexp-in-string "\\.\\(.*\\)" "_test.\\1" filename)))))

(defun source-file ()
  (let ((filename (buffer-file-name)))
    (cond ((string-match "_test\\." filename) ;; test file
           (replace-regexp-in-string "_test\\.\\(.*\\)" ".\\1" filename))
          ((string-match "\\.h" filename) ;; header file
           (replace-regexp-in-string "\\.h" ".cc" filename))
          (t  ;; source file
           filename))))

(defun header-file ()
  (let ((filename (buffer-file-name)))
    (cond ((string-match "_test\\." filename) ;; test file
           (replace-regexp-in-string "_test\\..*" ".h" filename))
          ((string-match "\\.h" filename) ;; header file
           filename)
          (t  ;; source file
           (replace-regexp-in-string "\\..*" ".h" filename)))))

(bind-key* "M-g M-s" (lambda ()
                     (interactive)
                     (find-file (source-file))))
(bind-key* "M-g M-t" (lambda ()
                     (interactive)
                     (find-file (test-file))))
(bind-key* "M-g M-h" (lambda ()
                     (interactive)
                     (find-file (header-file))))
