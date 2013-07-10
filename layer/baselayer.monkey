Import mojo

Class BaseLayer Abstract
	' 画像の横幅
	Field width:Int
	' 画像の縦幅
	Field height:Int
	' Image格納用マップ
	Field storeMap:StringMap<Image>
	
	Method New()
		Self.width = 800
		Self.height = 600
		storeMap = New StringMap<Image>
	End

	' Image格納用マップに指定のImageを追加する
	Method Append:Bool(key:String, data:String)
		Local img:Image
		img = LoadImage(data)
		Return Self.storeMap.Set(key, img)
	End
	
	' レイヤーに画像を設定する
	Method Set:Int(key:String, align:String="left") Abstract

	' 指定のImageをレイヤーに実際に描画する
	' alignは基本的に指定しなくて良い。
	Method Draw:Int() Abstract

	' 指定のregion（範囲）を消去する
	' regionは基本的に指定しなくて良い。
	Method Clear:Int(region:String="all") Abstract
	
	' レイヤーを完全に初期化する
	Method Init:Void() Abstract
End