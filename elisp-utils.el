(defmacro on-os (os &rest body)
  `(when (eq system-type ,os)
     ,@body))

(defmacro on-mac (&rest body) `(on-os 'darwin ,@body))
(defmacro on-linux (&rest body) `(on-os 'gnu/linux ,@body))
(defmacro on-windows (&rest body) `(on-os 'windows-nt ,@body)) ; 'ms-dos?
