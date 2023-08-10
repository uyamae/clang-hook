# clang-cl 呼び出しをフックするテスト

## 確認環境

- Windows 11 Home
- Visual Studio Community 2022
  - ClangCL ツールセットを含む
- CMake 3.27.0

## 実行方法

PowerShell やコマンドプロンプトでmakeproj.ps1 を実行すると
.\build\clang-hook.sln が生成されるので、これをVisual Studio で開いて
ソリューションのビルドを実行してください。

test プロジェクトのビルド時にclang-hook.exe が呼び出されます。
clang-cl.exe は終了コード1 を返しているのでビルドは失敗で終わります。
（呼び出されるプログラムの差し替えの確認だけが目的のため。）
