# 鋼構 3D 展示

3D 模型展示站，GitHub Pages：<https://ianyuchuang.github.io/3d/>

## 結構

- `index.html` — 入口，讀 `models.json` 列出可點選的模型
- `3d/` — 各個獨立的 3D 展示頁（單檔 HTML + three.js CDN）
- `models.json` — 模型清單，**自動產生，不要手改**
- `tools/gen-models.sh` — 掃描 `3d/*.html` 產生 `models.json`
- `tools/pre-commit` — git hook，commit 前自動重跑上面的產生器

## 新增模型

把新的 `.html` 丟進 `3d/`，然後：

    push.bat

`push.bat` 會先問要不要把未提交的改動 commit 起來（可直接打中文訊息），再 push。
只想 commit 不 push 就用 `commit.bat 訊息`（訊息請用英文，避免批次檔中文編碼問題）。

清單會在 commit 時自動更新（頁面標題取自該檔的 `<title>`，說明取自第一個 `<h1>`）。

## 首次設定

執行 `init-git.bat`（git init + 檢查 git 身分 + 安裝 hook + 首次 commit + 設定 remote），再執行 `push.bat`（會自動設 upstream）。
第一次會問 commit 用的名字與 email（`tools/check-identity.bat`，寫入 `git config --global`）；
公開倉庫的 commit 會顯示這個 email，不想露出 Gmail 就選 2 的 `@users.noreply.github.com`。
推上去後到 GitHub → Settings → Pages，Source 選 `main` / `root`。
