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
;; Evil 模式切換
;; ============================================================

;; 全局切換 Evil / 原生模式。
;; C-\ 在任何狀態下都可用，不依賴 Leader 鍵。
(map! :desc "切換 Evil 模式" "C-\\" #'evil-mode)


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


;; 隱藏菜單欄
(menu-bar-mode -1)
