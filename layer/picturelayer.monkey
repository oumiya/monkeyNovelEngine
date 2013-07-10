Import mojo
Import baselayer

Class PictureLayer Extends BaseLayer

	Field drawImage:Image

	Method Set:Int(key:String, align:String="left")
		Self.drawImage = storeMap.Get(key)
	End

	Method Draw:Int()
		If drawImage <> Null
			DrawImage drawImage, 0, 0
		Endif
		Return 0
	End

	Method Clear:Int(region:String="all")
		Self.drawImage = Null
	End

	Method Init:Void()
		storeMap = New StringMap<Image>
		drawImage = Null
	End	
End