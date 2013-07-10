Import mojo
Import baselayer

Class BgLayer Extends BaseLayer

	Field drawImage:Image

	' BGレイヤーではalignを指定する必要はありません。
	' というか指定しても何もしません。	
	Method Set:Int(key:String, align:String="left")
		Self.drawImage = storeMap.Get(key)
	End

	Method Draw:Int()
		If drawImage <> Null
			DrawImage drawImage, 0, 0
		Endif
		' 背景は一瞬で描画し終わるので、常に 0 を返す
		Return 0
	End

	' BGレイヤーではregionを指定する必要はありません。
	' というか指定しても何もしません。
	Method Clear:Int(region:String="all")
		Self.drawImage = Null
	End
	
	Method Init:Void()
		storeMap = New StringMap<Image>
		drawImage = Null
	End
End