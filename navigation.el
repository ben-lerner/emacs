;; buffer navigation
(require 'ace-jump-mode)
(bind-key* "C-c SPC" 'ace-jump-mode)

(bind-key* "M-SPC" (kbd "M-4 SPC"))

(bind-key* "M-n" 'forward-paragraph)
(bind-key* "M-p" 'backward-paragraph)

;;;; find the next/previous instance of token under cursor
(require 'evil)

(bind-key* "M-N" 'evil-search-word-forward)
(bind-key* "M-P" 'evil-search-word-backward)

; (define-key my-tab-minor-mode-map (kbd "C-<return>") (kbd "C-x C-s C-c C-a"))

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

(bind-key* "M-]" 'select-next-window)
(bind-key* "M-[" 'select-previous-window) ;; *don't* remap C-[
(use-package transpose-frame)

(bind-key* "C-x t" 'rotate-frame) ; 'transpose'


;; file navigation

(bind-key* "M-g M-n" 'goto-note)
(bind-key* "M-g M-l" 'goto-log)
(bind-key* "M-g M-q" 'goto-quotes)
(bind-key* "M-g M-t" 'goto-todo)
(bind-key* "M-g M-a" 'goto-archive)
(bind-key* "M-g M-r" 'cider-jack-in) ; goto-repl

(ido-mode)
