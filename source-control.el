(require 'magit)
(bind-key* "C-c C-g" 'magit-status)

;; todo: fix this not to prompt on magit-stage-file
;; (defun save-and-stage-file ()
;;   (interactive)
;;   (save-buffer)
;;   (if (vc-git-registered buffer-file-name)
;;       (magit-stage-file buffer-file-name)))

;; (bind-key* "C-x C-s" 'save-and-stage-file)

(setq magit-completing-read-function 'ivy-completing-read)

;; vdiff
(require 'vdiff)
(bind-key* "C-c h" 'vdiff-hydra/body)

;; (require 'vdiff-magit)
;; (define-key magit-mode-map "e" 'vdiff-magit-dwim)
;; (define-key magit-mode-map "E" 'vdiff-magit-popup)
;; (setcdr (assoc ?e (plist-get magit-dispatch-popup :actions))
;;         '("vdiff dwim" 'vdiff-magit-dwim))
;; (setcdr (assoc ?E (plist-get magit-dispatch-popup :actions))
;;         '("vdiff popup" 'vdiff-magit-popup))

;; This flag will default to using ediff for merges. vdiff-magit does not yet
;; support 3-way merges. Please see the docstring of this variable for more
;; information
;; (setq vdiff-magit-use-ediff-for-merges nil)

;; Whether vdiff-magit-dwim runs show variants on hunks.  If non-nil,
;; vdiff-magit-show-staged or vdiff-magit-show-unstaged are called based on what
;; section the hunk is in.  Otherwise, vdiff-magit-dwim runs vdiff-magit-stage
;; when point is on an uncommitted hunk.  (setq vdiff-magit-dwim-show-on-hunks
;; nil)

;; Whether vdiff-magit-show-stash shows the state of the index.
;; (setq vdiff-magit-show-stash-with-index t)

;; Only use two buffers (working file and index) for vdiff-magit-stage
;; (setq vdiff-magit-stage-is-2way nil)
