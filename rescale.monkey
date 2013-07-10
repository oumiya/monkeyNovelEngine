'HTML5プラットフォームでフルスクリーンモードを提供します。

'参考資料:
'http://www.monkeycoder.co.nz/Community/posts.php?topic=1157

#If TARGET<>"html5"
#Error "The rescale module is only available with the html5 target."
#End

Strict

Import "rescale.js"

Extern

Function Rescale:Int()

Function GetCanvasWidth:Int()

Function GetCanvasHeight:Int()