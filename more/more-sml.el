(defun my-sml-keys ()
  (define-key sml-mode-map (kbd "C-c C-c") '(lambda ()
					      (interactive)
					      (sml-prog-proc-load-file
					       (buffer-file-name)
					       'and-go)
					      (end-of-buffer)
					      (other-window 1)))
  (define-key sml-mode-map (kbd "C-M-x") 'sml-send-function)
  (define-key sml-mode-map (kbd "C-c C-h") '(lambda ()
					      (interactive)
					      (mark-till-here)
					      (sml-prog-proc-send-region))))

(defun load-sml ()
  (interactive)
  (when (not (package-installed-p 'sml-mode))
    (package-refresh-contents)
    (package-install 'sml-mode))
  ;; (require 'sml-mode)
  )

(add-hook 'sml-mode-hook 'my-sml-keys)
;; (global-set-key (kbd "<apps> <apps> m") 'load-sml)
