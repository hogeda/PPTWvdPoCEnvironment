# Windows Virtual Desktop 無償PoC環境構築
## 基本環境構築
- 任意のリソースグループを作成します。
-  次のボタンをクリックしてテンプレートよりデプロイを行います。このテンプレートではADサーバー用のVMを構築します。
    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fhogeda%2FPPTWvdPoCEnvironment%2Fmain%2Fazuredeploy.json)
- デプロイ終了後にはVMに接続、スクリプトを実行してAD構築、ユーザー作成を実施してください。
- パラメータは次の例を参考に入力してください。
   
| Parameter  | Sample    |
| --- | --- |
| virtualNetwork_name | [concat(resourceGroup().name,'-vnet')] |
| subnetworks | {"value":[{"name":"snet-enterprise","addressPrefix":"10.0.0.0/24"},{"name":"snet-wvd","addressPrefix":"10.0.1.0/24"}],"Count":2} |
| subnetNameOfAD | snet-enterprise |
| virtualMachineName | adds01 |
| adminUsername | pptadmin |
| adminPassword | WVDPoC#123098! |

## WVD環境構築
準備中
