;;; -*- lexical-binding: t; -*

;;
;; Minimap
(setq demap-minimap-window-side 'right)
(setq demap-minimap-window-width 15)

;;(ad-hook 'find-file-hook
;;         (lambda()
;;            (when (and buffer-file-name
;;                       (not (minibufferp))
;;                       (not (string-match-p "^\\*" (buffer-name)))
;;                       (derived-mode-p 'prog-mode)
;;                       (not (get-buffer "*demap*"))
;;              (demap-open))
;;              (setq-local show-trailing-whitespace nil)
;;              (when (bound-and-true-p whitespace-mode)
;;                (whitespace-mode -1)
;;              (setq-local display-line-numbers nil)
;;              (setq-local global-hl-line-mode nil)
;;              (text-scale-set -1))


;;
;; Modeline
(setq doom-modeline-height 22
      doom-modeline-icon t
      doom-modeline-env-version t
      doom-modeline-buffer-encoding t
      doom-modeline-buffer-file-name-style 'truncate-except-project
      doom-modeline-indent-info t
      doom-modeline-lsp nil
      doom-modeline-lsp-icon nil
      doom-modeline-modal t
      doom-modeline-modal-modern-icon t
      doom-modeline-time-live-icon t
      doom-modeline-vcs-display-function #'doom-modeline-vcs-name
      doom-modeline-vcs-icon t
      doom-modeline-vcs-max-length 15
      doom-modeline-vcs-state-faces-alist
      '((needs-update . (doom-modeline-warning bold))
        (removed . (doom-modeline-urgent bold))
        (conflict . (doom-modeline-urgent bold))
        (unregistered . (doom-modeline-urgent bold)))
      doom-modeline-workspace-name t)

;;
;; Treemacs
(setq treemacs-width 30)
(lsp-treemacs-sync-mode 1)

;;
;; Projectile
(after! projectile
  (add-hook 'projectile-after-switch-project-hook
            (lambda ()
              (treemacs-add-and-display-current-project)
              (treemacs-select-window))))
