'HTML5プラットフォームで高速に動作するベクトルテキスト機能を提供します。
'（mojoと組み合わせて使用します。）

'参考資料:
'http://dev.w3.org/html5/2dcontext/#dom-context-2d-font
'http://dev.w3.org/html5/2dcontext/#drawing-text-to-the-canvas
'http://www.w3.org/TR/css3-fonts/

#If TARGET<>"html5"
#Error "The canvastext module is only available with the html5 target."
#End

Strict

Import "canvastext.js"

Extern

'CanvasのFontを設定します。
'引数のfntに渡す文字列は、CSSのfontプロパティに構文に従ってください。
'fnt: CSS font property syntax. <a href="http://www.w3.org/TR/css3-fonts/#font-prop" target="_blank">http://www.w3.org/TR/css3-fonts/#font-prop</a>
Function SetCanvasFont:Void(fnt:String)

'Canvasの指定の座標にTextを描画します。
Function DrawCanvasText:Void(txt:String, x:Float, y:Float)

'Canvasの指定の座標にTextをmaxwidthに指定した幅に収まるように描画します。
'（幅が狭い場合は押しつぶされたような感じで描画されます）
Function FitCanvasText:Void(txt:String, x:Float, y:Float, maxwidth:Float)

'Textのアラインメント（位置合わせ）を設定します。
'start, end, left, right, centerのいずれかを設定できます。
'ta: possible values are start, end, left, right, and center.
'http://dev.w3.org/html5/2dcontext/#text-styles 
Function SetCanvasTextAlign:Void(ta:String)

'Textのベースライン（縦位置）を設定します。
'top, hanging, middle, alphabetic, ideographic, bottom のいずれかを設定できます。
'bl: possible values are top, hanging, middle, alphabetic, ideographic, bottom.
'http://dev.w3.org/html5/2dcontext/#text-styles.
Function SetCanvasTextBaseline:Void(bl:String)

'Canvasに描画した場合の横幅を計算して取得します。
'Get the width of txt, calculated on the current canvas font settings.
Function GetCanvasTextWidth:Float(txt:String)
