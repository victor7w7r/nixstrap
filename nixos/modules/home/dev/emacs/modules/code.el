;;; -*- lexical-binding: t; -*

(setq-default tab-width 2)
(setq-default indent-tabs-mode t)

(require 'hungry-delete)
(global-hungry-delete-mode)
(auto-rename-tag-mode t)
(global-evil-matchit-mode 1)
(require 'toggle-quotes)

(after! lsp-mode
  (setq lsp-enable-snippet t
        lsp-headerline-breadcrumb-enable t
        lsp-modeline-code-actions-enable t)
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-show-with-mouse t))

(after! lsp-ui
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.1
        lsp-ui-doc-border (face-foreground 'default)))

(defun kotlin-setup ()
  (when (and (projectile-project-p)
             (or (projectile-verify-file "build.gradle")
                 (projectile-verify-file "build.gradle.kts")))
    (when (fboundp 'lsp)
      (lsp))
    (let ((default-directory (projectile-project-root)))
      (compile "gradle tasks --quiet"))))

(add-hook 'projectile-after-switch-project-hook #'kotlin-setup)

(defun treesitter-langfs-apply ()
  "Verify Tree Sitter Langs"
  (dolist (lang '(css dart dockerfile html java javascript json kotlin python rust sql tsx toml typescript vue yaml))
    (unless (treesit-language-available-p lang)
      (ignore-errors (treesit-install-language-grammar lang)))))

(add-hook 'doom-after-init-hook #'treesitter-langfs-apply)
