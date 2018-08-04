(defmacro on-os (os &rest body)
  `(when (eq system-type ,os)
     ,@body))

(defmacro on-mac (&rest body) `(on-os 'darwin ,@body))
(defmacro on-linux (&rest body) `(on-os 'gnu/linux ,@body))
(defmacro on-windows (&rest body) `(on-os 'windows-nt ,@body)) ; 'ms-dos?

(defmacro with-existing-window (&rest body)
  ;; don't create a new window while running body unless
  ;; it's called from the only window in the frame
  `(progn
     (when (= (length (window-list)) 1)
       (split-window-right))
     (setq pop-up-windows nil)
     ,@body
     (setq pop-up-windows t)))
