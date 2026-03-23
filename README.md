# Gemini CLI

本專案依據 [Gemini CLI](https://geminicli.com/docs/) 介紹，建立 [Gemini Code Assist](https://codeassist.google/) 操作環境並實務測試。

Gemini CLI 需使用 Google 帳號，且訂閱方案需為 Google AI Plus、Pro、Ultra 方案或 API 用量計費。

+ 帳號若採用訂閱方案，Gemini 於 [Claude App](https://gemini.google.com/) 使用。
	- 目前 Gemini 並未提供 Windows、Mac 環境使用的應用程式。
  - 本專案提供常駐服務與登入流程說明
+ 帳號若採用 API 用量計費，開發者可開發個人服務調用 Gemini。
  - 本專案提供 API 金鑰設定與登入流程說明

## 指令

使用 [devops-cli-framework](https://github.com/eastmoon/devops-cli-framework) 設計專案指令：

+ 啟動開發環境 ```do.bat dev```
+ 執行單句提示 ```do.bat prompt [ask question]```
	- 例如：```do.bat prompt Say hello and tell me what you can help with```
+ 執行計畫檔案 ```do.bat plan [markdown file in 'plan' folder]```
	- 例如：```do.bat plan demo.md```，demo.md 檔案在 [plan](./plan) 目錄中
+ 啟動常駐服務 ```do.bat srv```

執行上述指令需於 [devops-cli-framework](https://github.com/eastmoon/devops-cli-framework) 專案執行 ```do pack```，封裝必要映像檔。

## 環境容器

環境建立參考 [Gemini CLI installation](https://geminicli.com/docs/get-started/installation/) 文獻。

實務完成的容器映像檔參考 [Dockerfile](./conf/docker/gemini-cli)

## 登入帳號

### API 金鑰

若使用 Docker 啟動容器執行一次性指令，採用 Gemini API 用量計費方式執行。

用戶如下方式產生 API 權杖：

1. 前往 [Google AI Studio](https://aistudio.google.com/)。
2. 點擊左側的 "Get API key"。
3. 選擇 "Create API key in new project"。
4. 複製 API Key 並妥善保存（這是免費的，但有每分鐘調用次數限制）。

申請權杖後，用戶需先提升 API 擁有調用權限：

1. 前往 [Google AI Studio - Keys](https://aistudio.google.com/api-keys)。
2. 選擇 API Key 並點擊 "Set up billing" 綁定為費金鑰。

確認邦定完畢，可於並於 [Google Cloud Console - 帳單頁面](https://console.cloud.google.com/billing) 檢查 API Key 所屬專案的帳單；需注意，Google Cloud / Gemini API 費用是根據您當月的實際調用量，在次月從信用卡扣款，由於 Google 不會主動凍結帳單，對於超過額度會採用以下方式：

1. 調整配額，確保每日調用額度不會超過預期金額。
2. 設定終止自動化，其原理為 ```預算警報通知 → Pub/Sub (訊息傳遞) → Cloud Functions (自動化腳本) → 停用帳單```。
3. 使用預測警報，設定支出預警，當達到條件，發送信件通知用戶。

取得權杖後，於本專案執行如下操作：

1. 將權杖複製至本專案檔案 ```./conf/devops/keys/GEMINI_API_KEY```
2. 執行 ```do.bat dev``` 啟動環境，啟動程序會檢查 GEMINI_API_KEY 檔案並設定相應環境變數給容器
3. 進入容器後，執行 ```gemini -p "Say hello and tell me what you can help with"``` 執行簡單詢問是否可以執行。

依據實際測試，```do prompt``` 或 ```do plan``` 執行 4 次費用合計 0.07 USD，估算單次 0.0175 USD。
> Google 帳單需等待數小時，量測時須確保等待期間不會額外再執行服務。

### Google 用戶

若使用 Docker 啟動容器常駐登入狀態，可採用 Gemini 訂閱方案方式執行；原則上，此方式等同於本機安裝，只是透過容器與主機隔離。

其操作方式如下：

1. 執行 ```do.bat srv``` 啟動服務，並自動進入 Gemini CLI 的互動介面。
2. 選擇 ```Sing in with Google```。
3. 取得認證用網址，前往可認證該網址的瀏覽器。
4. 選擇帳戶，並取得驗證碼
5. 回到 Gemini CLI 互動介面複製驗證碼，等候服務啟動完畢

執行詢問方式如下：

1. 執行 ```docker exec -ti gemini-cli-srv bash``` 進入容器
2. 執行 ```gemini -p "What is gemini"``` 詢問內容

需注意，目前使用此方式登入，會出現以下問題：

+ 登入的介面會卡住，將無法繼續使用。
	- 可以透過 ```docker rm -f xxxxxx``` 強制將映像為 devsop-cli-fw 的容器移除。
+ 執行 ```gemini -p``` 詢問時會有各種執行錯誤，導致無法正常運作或執行失敗。
	- 少數狀況下可以正常完成指令。
