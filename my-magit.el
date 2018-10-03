(require 'magit)
(bind-key "C-c g" 'magit-status)

;; todo: fix this not to prompt on magit-stage-file
;; (defun save-and-stage-file ()
;;   (interactive)
;;   (save-buffer)
;;   (if (vc-git-registered buffer-file-name)
;;       (magit-stage-file buffer-file-name)))

;; (bind-key* "C-x C-s" 'save-and-stage-file)

(setq magit-completing-read-function 'ivy-completing-read)
