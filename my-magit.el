(require 'magit)
(bind-key "C-c g" 'magit-status)

(defun save-and-stage-file ()
  (interactive)
  (save-buffer)
  (magit-stage-file buffer-file-name))

(bind-key* "C-x C-s" 'save-and-stage-file)
