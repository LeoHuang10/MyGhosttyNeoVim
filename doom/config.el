;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ============================================================
;; 字體設置
;; ============================================================

;; 使用霞鶩文楷 GB 等寬字體。
(setq doom-font
      (font-spec
       :family "LXGW WenKai Mono GB"
       :size 14))


;; ============================================================
;; 主題設置
;; ============================================================

;; 使用 Doom One 主題。
(setq doom-theme 'doom-one)


;; ============================================================
;; 行號設置
;; ============================================================

;; 開啟行號。
(setq display-line-numbers-type t)


;; ============================================================
;; Org 模式
;; ============================================================

;; Org 文件默認保存目錄。
(setq org-directory "~/org/")


;; ============================================================
;; Corfu 自動補全
;; ============================================================

;; Corfu 負責顯示代碼補全候選選單。
;; LSP 通過 Completion-at-Point 提供補全候選。
(after! corfu
  (setq corfu-auto t
        corfu-auto-prefix 2
        corfu-auto-delay 0.2
        corfu-cycle t
        corfu-preselect 'prompt)

  (global-corfu-mode 1))


;; ============================================================
;; Corfu 終端支持
;; ============================================================

;; Emacs 30 的終端使用 corfu-terminal 顯示補全選單。
(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                (unless (display-graphic-p)
                  (corfu-terminal-mode 1))))))

(unless (daemonp)
  (unless (display-graphic-p)
    (corfu-terminal-mode 1)))


;; ============================================================
;; Emacs 原生 Completion
;; ============================================================

;; TAB 在可以補全時執行補全，否則保持原本的縮進功能。
(setq tab-always-indent 'complete)


;; ============================================================
;; LSP
;; ============================================================

;; 使用 LSP 提供代碼補全、診斷、跳轉和符號查找。
(after! lsp-mode
  (setq lsp-completion-provider :capf))


;; ============================================================
;; 原生 Emacs 操作
;; ============================================================

;; 不使用 Evil。
;; 使用純粹的 Emacs 原生鍵位。

;; C-f       向右
;; C-b       向左
;; C-n       向下
;; C-p       向上
;; C-a       行首
;; C-e       行尾
;; C-d       刪除字符
;; C-k       刪除到行尾
;;
;; C-x C-f   打開文件
;; C-x C-s   保存文件
;; C-x C-w   另存為
;; C-x b     切換 Buffer
;; C-x o     切換窗口
;; C-x 2     水平分割
;; C-x 3     垂直分割
;; C-x 0     關閉當前窗口
;; C-x 1     保留當前窗口
;;
;; M-x       執行 Emacs 命令
;; C-g       取消操作
;; C-h       幫助


;; ============================================================
;; macOS GUI
;; ============================================================

;; GUI Emacs 啟動時自動最大化窗口。
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (when (display-graphic-p)
                (set-frame-parameter frame
                                     'fullscreen
                                     'maximized)))))
