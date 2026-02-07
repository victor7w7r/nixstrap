;;; -*- lexical-binding: t; -*-

(move-text-default-bindings)

(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(global-set-key (kbd "C-S-p") 'execute-extended-command)
(global-set-key (kbd "C-/") 'comment-line)
(global-set-key (kbd "C-b") 'treemacs)
(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-S-tab>") 'previous-buffer)

(global-set-key (kbd "<home>") 'mwim-beginning-of-line-or-code)
(global-set-key (kbd "<end>") 'mwim-end-of-line-or-code)

(global-set-key (kbd "C-'") 'toggle-quotes)

(map!
 :leader
 :desc "Reveal in Treemacs"
 "t k" #'treemacs-find-file

 :leader
 :desc "Buffer Diagnostics"
 "e b" #'flymake-show-buffer-diagnostics

 :leader
 :desc "Project Diagnostics"
 "e p" #'flymake-show-project-diagnostics)

(setq evil-disable-insert-state-bindings t)

(defun indent-keybind ()
  "Indent Keybind"
  (interactive)
  (if (use-region-p)
      (indent-rigidly (region-beginning) (region-end) (- tab-width))
    (indent-rigidly (line-beginning-position) (line-end-position) (- tab-width))))

(global-set-key (kbd "<backtab>") #'indent-keybinding)
(map! :i "<backtab>" #'indent-keybinding)
(map! :v "<backtab>" #'indent-keybinding)

(defun insert-tab-char ()
  "Insert Tab Char"
  (interactive)
  (insert "\t"))

(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
