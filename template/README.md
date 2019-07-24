1. Spinnaker のPipelineを新規作成
2. Configuration stageの各種設定を行う
    * Artifact の定義 (必ず以下の順番で定義するように)
        * manifest.yaml
        * manifest_rs.yaml
        * manifest_ing.yaml
        * manifest_svc_dummy.yaml
    * Automated Triggers の定義
    * Notifications の定義
3. `Pipeline Actions` > `Edit as JSON` を押下
4. 出力されたjsonを全選択コピー
5. ローカルに新規ファイルを作成しjsonをペースト
6. 各種環境変数の設定
```
APPLICATION=<Spinnaker Application名>
PROVIDER=<Provider(デプロイ先クラスタ)>
NAMESPACE=<デプロイ先クラスタにて使用するnamespace>
SERVICE_NAME=<デプロイするServiceリソースの.metadata.name>
INGRESS_NAME=<デプロイするIngressリソースの.metadata.name>
```
7. `python create-json.py template.json <5.で作成したファイル名>`
    * macOSならば、パイプしてpbcopyに食わせるとクリップボードにコピーされる (`python create-json.py template.json <5.で作成したファイル名> | pbcopy`)
8. 出力を `Edit as JSON` の画面に貼り付けて保存
