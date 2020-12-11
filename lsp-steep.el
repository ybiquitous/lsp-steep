;;; lsp-steep.el --- Steep support for lsp-mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Masafumi Koba

;; Version: 0.1.0
;; Package-Requires: ((emacs "26.1") (lsp-mode "7.0"))
;; Author: Masafumi Koba
;; Keywords: languages, tools
;; URL: https://github.com/ybiquitous/lsp-steep

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Steep (a static type checker for the Ruby language) support for lsp-mode.

;;; Code:
(require 'lsp-mode)

(defgroup lsp-steep nil
  "LSP support for Steep, a static type checker for Ruby."
  :group 'lsp-mode
  :link '(url-link "https://github.com/soutaro/steep"))

(defcustom lsp-steep-use-bundler nil
  "Run Steep under Bunder."
  :type 'boolean
  :group 'lsp-steep)

(defcustom lsp-steep-log-level "warn"
  "Log level of Steep."
  :type '(choice
           (const "fatal")
           (const "error")
           (const "warn")
           (const "info")
           (const "debug"))
  :group 'lsp-steep)

(defun lsp-steep--command ()
  "Return the Steep command."
  (append
    (if lsp-steep-use-bundler '("bundle" "exec"))
    '("steep" "langserver")
    (list (concat "--log-level=" lsp-steep-log-level))))

(defun lsp-steep--initialize (workspace)
  "Initialize `lsp-steep' with WORKSPACE."
  (with-lsp-workspace workspace
    (lsp--set-configuration
      (lsp-configuration-section "steep"))))

(lsp-register-client
  (make-lsp-client
    :new-connection (lsp-stdio-connection #'lsp-steep--command)
    :major-modes '(ruby-mode enh-ruby-mode)
    :priority -1
    :multi-root t
    :server-id 'ruby-steep
    :initialized-fn #'lsp-steep--initialize))

(provide 'lsp-steep)
;;; lsp-steep.el ends here
