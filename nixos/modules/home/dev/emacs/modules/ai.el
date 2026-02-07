;;;; init.el -*- lexical-binding: t; -*-

;;(custom-set-variables
;; '(lsp-augment-enabled t)
;; '(lsp-augment-server-script "/home/victor7w7r/.emacs.d/.local/straight/repos/augment.vim/dist/server.js")

;;(setq lsp-augment-additional-context-folders
;;      '("~/repositories")

;;(add-to-list 'load-path "/home/victor7w7r/.emacs.d/.local/straight/repos/augment.vim/emacs/")
;;(require 'lsp-augment)

;;(add-hook 'typescript-mode-hook #'lsp)
;;(add-hook 'web-mode-hook #'lsp)

;;(custom-set-variables
;; '(lsp-augment-enabled t)
;; '(lsp-augment-server-script "/home/victor7w7r/.emacs.d/.local/straight/repos/augment.vim/dist/server.js")

;;(setq lsp-augment-additional-context-folders
;;'("~/repositories")

;;(add-to-list 'load-path "/home/victor7w7r/.emacs.d/.local/straight/repos/augment.vim/emacs/")
;;(require 'lsp-augment)

;;(add-hook 'typescript-mode-hook #'lsp)
;;(add-hook 'web-mode-hook #'lsp)

(after! copilot
  (defun copilot--infer-indentation-offset ()
    (or (and (boundp 'tab-width) tab-width)
        2)))
