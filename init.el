(add-to-list 'load-path "~/repos/emacs/evil/")
(add-to-list 'load-path "~/repos/emacs/dash.el/")
(add-to-list 'load-path "~/repos/emacs/monitor/")
(add-to-list 'load-path "~/repos/emacs/org-evil/")
(add-to-list 'load-path "~/repos/emacs/evil/lib")
(require 'undo-tree)
(require 'evil)
(evil-mode 1)
(require 'dash)
(require 'monitor)
(require 'org-evil)

(setq org-todo-keywords
      '((sequence "TODO" "WAITING" "|" "DONE")))
;;set priority range from A to C with default A
(setq org-highest-priority ?1)
(setq org-lowest-priority ?5)
(setq org-default-priority ?1)
(define-key global-map "\C-ca" 'org-agenda) 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/repos/personal_todos/todos.org" "~/repos/work_todos/todo.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
