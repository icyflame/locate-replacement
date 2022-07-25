;; Originally inspired from git-grep integration with counsel:
;;   https://oremacs.com/2015/04/19/git-grep-ivy/
(defun ivy-locate-replacement-helper-function (string &optional _pred &rest _u)
  "Grep in the current git repository for STRING."
  (split-string
   (shell-command-to-string
    (format
     "cat ~/.locate-simple-replacement-index | /usr/bin/rg --ignore-case \"%s\""
     string))
   "\n"
   t))

(defun ivy-locate-replacement-helper ()
  "Grep for a string in the current git repository."
  (interactive)
  (let ((default-directory (locate-dominating-file
                             default-directory ".git"))
        (val (ivy-read "pattern: " 'ivy-locate-replacement-helper-function))
        lst)
	;; This part is not required because it opens the output of the grep command
    (when val
      (setq lst (split-string val ":"))
      (find-file (car lst))
      (goto-char (point-min))
      (forward-line (1- (string-to-number (cadr lst)))))))

;; Now, the function works as required. But it keeps searching on every single keypress. That is not
;; performant enough. Instead, we have to use C-m, C-j, and RET in conjunction, so that C-j will
;; update the list of suggestions, and RET will actually enter that file; while typing a single
;; keypress will not run any shell command at all.
;;
;; Follow this guide: https://oremacs.com/2019/06/27/ivy-directory-improvements/
