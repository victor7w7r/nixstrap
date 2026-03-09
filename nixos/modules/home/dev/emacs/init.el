;;; init.el -*- lexical-binding: t; -*-

(setq evil-want-keybinding nil)

(doom! :completion
       (corfu +dabbrev +icons +orderless)
       (vertico +icons)

       :ui
       deft
       doom
       doom-dashboard
       doom-quit
       (emoji +unicode +github)
       hl-todo
       indent-guides
       ligatures
       minimap
       modeline
       ophints
       (popup +defaults)
       tabs
       (treemacs +lsp)
       (vc-gutter +pretty)
       vi-tilde-fringe
       (window-select +numbers +switch-window)
       (workspaces +tabs)
       zen

       :editor
       (evil +everywhere)
       fold
       (format +onsave +lsp)
       multiple-cursors
       parinfer
       rotate-text
       ;;snippets
       (whitespace +guess +trim)
       word-wrasp

       :emacs
       (dired +dirvish +icons)
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       (syntax +childframe +flymake +icons)

       :tools
       debugger
       direnv
       (docker +lsp +tree-sitter)
       editorconfig
       (eval +overlay)
       llm
       (lookup +docsets +dictionary +offline)
       (lsp +peek)
       magit
       make
       pdf
       tmux
       tree-sitter

       :os
       tty

       :lang
       (dart +flutter +lsp +tree-sitter)
       data
       emacs-lisp
       (java +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (json +lsp +tree-sitter)
       (kotlin +lsp +tree-sitter)
       (lua +lsp +tree-sitter)
       (markdown +tree-sitter)
       (nix +lsp +tree-sitter)
       (python +lsp +tree-sitter +poetry +pyright)
       (rest +jq)
       (rust +lsp +tree-sitter)
       (sh +powershell +lsp)
       (web +lsp +tree-sitter)
       (yaml +tree-sitter)

       :config
       (default +bindings +smartparens))
