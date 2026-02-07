;;; $DOOMDIR/config.el -*- lexical-binding: t; -*

(setenv "PATH" (concat (getenv "PATH") ":$HOME/.local/share/mise/shims"))
(setq exec-path (append exec-path '("~/.local/share/mise/shims")))
(setenv "JAVA_HOME" "/home/victor7w7r/.local/share/mise/installs/java/openjdk-21")
(setenv "GRADLE_HOME" "/home/victor7w7r/.local/share/mise/installs/gradle/latest")

(setq projectile-project-search-path '("~/repositories/" "~/repositories/TCM/"))

(load! "modules/clipboard")
(load! "modules/layout")
(load! "modules/ai")
(load! "modules/keybindings")
(load! "modules/theme")
(load! "modules/code")
