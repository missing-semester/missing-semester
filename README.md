# The Missing Semester of Your CS Education (日本語版) [![Build Status](https://github.com/missing-semester-jp/missing-semester-jp.github.io/workflows/CI/badge.svg)](https://github.com/missing-semester-jp/missing-semester-jp.github.io/actions?query=workflow%3ACI)



[The Missing Semester of Your CS Education (日本語版)](https://missing-semester-jp.github.io/) のウェブサイトです！

本ページは[The Missing Semester of Your CS Education](https://github.com/missing-semester/missing-semester)を邦訳したものになります。

issues/PRによる貢献は歓迎です。実際に各セクションの翻訳を行いたい場合は次の手順に従ってください。

## How to translate
- [issues](https://github.com/missing-semester-jp/missing-semester-jp.github.io/issues)にて、翻訳対象のファイルごとにissueが立っています。closeされているものはもう翻訳が終わっています。対象のissueにて自分自身をassignしてください（更新が被ることを防ぐため）。このとき、[@matsui528](https://github.com/matsui528), [@makotoshimazu](https://github.com/makotoshimazu), [@take1108](https://github.com/take1108) の三人にもメンションをしてください。ちなみにissueで既に誰かがassignされていた場合は既にその人が翻訳中です。
- ブランチを作り、翻訳を行い、PRを作ってください。PR中では上記issueをメンションしてください。レビュアには上記三人を指定してください。
- masterにマージされたあと、issueから自分をunassignしてください。



## Development

ローカルでビルドするには、次のコマンドを実行してください。

```bash
bundle exec jekyll serve -w
```

あるいは`docker`を使う場合は、以下のコマンドで環境を汚さずにビルドができます
```bash
docker run --rm --volume="$PWD:/srv/jekyll" -p 4000:4000 -it jekyll/jekyll jekyll serve -w
```

## Translator
- [@matsui528](https://github.com/matsui528)
- [@makotoshimazu](https://github.com/makotoshimazu)
- [@take1108](https://github.com/take1108)


## License

All the content in this course, including the website source code, lecture notes, exercises, and lecture videos is licensed under Attribution-NonCommercial-ShareAlike 4.0 International [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). See [here](https://missing.csail.mit.edu/license) for more information on contributions or translations.
