;;; kdl-mode.el simple mode for KDL -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 Grigoriy Bakunov
;;
;; Author: Grigoriy Bakunov <bobuk@rubedo.cloud
;; Maintainer: Grigoriy Bakunov <bobuk@rubedo.cloud>
;; Created: January 31, 2024
;; Modified: January 31, 2024
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/bobuk/kdl-mode
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;
;;
;;; Code:
(provide 'kdl-mode)

(eval-when-compile
  (require 'rx))

(defconst kdl--font-lock-defaults
  (let ((keywords '()) ;; that's pitty but kdl have no keywords
        (types '("u8" "u16" "u32" "u64" "i8" "i16" "i32" "i64")))
    `(((,(rx-to-string `(: (or ,@keywords))) 0 font-lock-keyword-face)
       ("\\([[:word:]]+\\)\s*(" 1 font-lock-function-name-face)
       (,(rx-to-string `(: (or ,@types))) 0 font-lock-type-face)
       ("//.*$" 0 font-lock-comment-face)
       ))))

(defun kdl-indent-line ()
  (let (indent
        boi-p
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      (when boi-p
        (setq move-eol-p t))
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\}))
        (setq indent (1- indent)))
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* tab-width indent)))
    (when move-eol-p
      (move-end-of-line nil))))

(defvar kdl-mode-abbrev-table nil
  "Abbreviation table used in `kdl-mode' buffers.")

(define-abbrev-table 'kdl-mode-abbrev-table
  '())

(define-derived-mode kdl-mode prog-mode "kdl"
  "Major mode for kdl files."
  :abbrev-table kdl-mode-abbrev-table
  (setq font-lock-defaults kdl--font-lock-defaults)
  (setq-local comment-start "//")
  (setq-local comment-start-skip "/-")
  (setq-local indent-line-function #'kdl-indent-line)
  (setq-local indent-tabs-mode t))

(add-to-list 'auto-mode-alist '("\\.kdl" . kdl-mode))

;;; kdl-mode.el ends here
