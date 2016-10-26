;; Package settings
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(custom-set-faces
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 90 :width normal)))))


;; Backup settings.
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs.s"))
 delete-old-versions t
 kept-new-versions 3
 kept-old-versions 2
 version-control t)


;; Preferences.
(set-language-environment "UTF-8")
(put 'narrow-to-region 'disabled nil)
(setq inhibit-splash-screen t)
(setq tab-width 4)
(setq org-src-fontify-natively t)
;; (setq scroll-margin 3)
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq-default outline-blank-line t)


;; Minor-modes
;; - close for simplifying views
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
;; - open for easy use
(electric-pair-mode 1)
(global-auto-revert-mode 1)
(global-linum-mode 1)
(show-paren-mode 1)


;; Compile commands
(global-set-key (kbd "<C-return>") 'compile)
(global-set-key (kbd "<C-M-return>") 'recompile)

(defun hook-compile-command (hook form)
  (eval `(add-hook ',hook (lambda ()
                            (set (make-local-variable 'compile-command)
                                 ,form)))))

(let ((bfn '(buffer-file-name))
      (bfn0 '(file-name-sans-extension (buffer-file-name))))
  (hook-compile-command 'python-mode-hook `(format "python \"%s\"" ,bfn))
  (hook-compile-command 'scala-mode-hook `(format "scala \"%s\"" ,bfn))
  (hook-compile-command 'haskell-mode-hook `(format "ghc -Wall \"%s\"" ,bfn))
  (hook-compile-command 'c-mode-hook `(format "gcc -g -o %s \"%s\""
                                              ,bfn0 ,bfn))
  (hook-compile-command 'c++-mode-hook
                        `(format "g++ -std=c++14 -g -Wall -O0 -o \"%s\" \"%s\""
                                 ,bfn0 ,bfn)))


;; C++ stuff
(add-hook 'c++-mode-hook
          (lambda ()
            (define-key c++-mode-map (kbd "C-c C-.")
              (let ((bfn0 (file-name-sans-extension (buffer-file-name))))
                (shell-command (format "\"./%s\"" bfn0))))))


;; Python stuff
(custom-set-variables
 '(gud-pdb-command-name "python -m pdb"))
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map (kbd "C-c C-d") 'pdb)
            (when (fboundp 'jedi:setup)
              (jedi-mode 1))
            ))
(global-set-key (kbd "C-M-]") 'delete-pair)


;; Further utilities
(global-set-key (kbd "C-M-=") 'hs-minor-mode)
(add-hook 'hs-minor-mode-hook
	  (lambda ()
            (define-key hs-minor-mode-map (kbd "C-`")
              (lambda (arg)
                "Easy folding with specified level."
                (interactive "c")
                (let ((val (- arg 48)))
                  (if (zerop val) (hs-show-all) (hs-hide-level val)))))))


(defun increase-face-size (x)
  (let ((h (face-attribute 'default :height)))
    (set-face-attribute 'default nil :height (+ h x))))

(global-set-key (kbd "C-=") (lambda () (interactive) (increase-face-size 5)))
(global-set-key (kbd "C--") (lambda () (interactive) (increase-face-size -5)))
(global-set-key (kbd "C-<up>") (lambda () (interactive) (scroll-down 2)))
(global-set-key (kbd "C-<down>") (lambda () (interactive) (scroll-up 2))) 

