# Dither

デイリーポータルZの「[レトロPCゲームみたいな写真が取りたい](https://dailyportalz.jp/kiji/retro_PC_game-mitaina-shashin)」という記事に感動して、この記事を参考にディザリング処理をシェーダーを使って実装したUnityプロジェクトです。

## 使い方

1. Unity (2022.1.2f1 以上)でプロジェクトを開き、`Assets`フォルダに [レトロPCゲームみたいな写真が取りたい]の記事にある[palette.png](https://img.dailyportalz.jp/2016/5749/6530/palette.png)を配置して下さい。
2. `Materials/Dither` の `Color Palette Texture` に 1で読み込んだ `palette` を指定して下さい。
3. `Scenes/SampleScene` を開くと、ディザリングする前後の画像が表示されます。

## 注意事項
* `Color Palette Texture`が正しく設定できていない場合、表示される色味がおかしくなります。
* 画像の表示スケールが適切でない場合、エイリアシングが発生しディザリングの結果が正しくないように見える場合があります。その場合は、画像の表示スケールを調整してみて下さい。