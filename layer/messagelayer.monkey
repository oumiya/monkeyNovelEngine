Import mojo
Import baselayer
Import canvastext

Class MessageLayer Extends BaseLayer
	Field text:String '表示メッセージ
	Field message:String[5] '表示メッセージ配列
	Field name:String '表示名
	Field drawImage:Image '表示ウィンドウ 指定しない場合は半透明の黒ウィンドウをデフォルトで表示
	Field padding:Int ' メッセージウィンドウの余白
	Field isDraw:Bool ' メッセージを描画するかどうか
	Field isDrawComplete:Bool
	Field writeIndex:Int ' メッセージを何文字目まで描画したか
	Field writeLine:Int ' メッセージを何行目まで描画したか
	
	Method New()
		Self.padding = 8
		Self.isDraw = False
		Self.writeIndex = 0
		Self.isDrawComplete = False
	End
	
	Method SetMessage(name:String, text:String)
		Self.name = name
		Self.text = text
		Self.message = New String[5]
		Self.message[0] = ""
		Self.message[1] = ""
		Self.message[2] = ""
		Self.message[3] = ""
		Self.message[4] = ""
		Self.writeIndex = 0
		Self.writeLine = 0

		Self.isDraw = True
		Self.isDrawComplete = False
	End

	Method Set:Int(key:String, align:String="left")
		Self.drawImage = storeMap.Get(key)
	End

	Method Draw:Int()
		Local result:Int=0

		If Self.isDraw = True
			' ウィンドウの描画
			' ウィンドウは画面の1/4の位置
			Local x:Float = 0.0, y:Float = 0.0
			Local windowheight:Float = height / 4
			y = windowheight * 3
	
			If drawImage <> Null
				DrawImage drawImage, x, y
			Else
				SetColor 0, 0, 0
				SetAlpha 0.5
				DrawRect x, y, width, windowheight
			Endif
			
			' 文字の描画
			SetColor 255, 255, 255
			SetAlpha 1
			
			Local textwidthlimit:Float = width - 5 - padding * 2

			If Self.writeIndex < Self.text.Length
				Local line:String
				Local textwidth:Float = 0.0
				Local char:String = ""
				
				line =  Self.message[Self.writeLine]

				char = String.FromChar(Self.text[writeIndex])
				If char = "~n"
					If Self.writeLine < 4
						Self.writeLine += 1
					Endif
				Else
					Local tmpLine:String = line + char
					textwidth = GetCanvasTextWidth(tmpLine)

					If textwidth > textwidthlimit
						If Self.writeLine < 4
							Self.writeLine += 1
							line = char
						Endif
					Else
						line = tmpLine
					Endif
					Self.message[Self.writeLine] = line
				Endif
				
				Self.writeIndex += 1
				result = 1
			Else
				result = 0
			Endif

			' メッセージの表示
			x = x + padding
			y = y + padding
			DrawCanvasText(name, x, y)
			y += 30
			DrawCanvasText(message[0], x+5, y)
			y += 22
			DrawCanvasText(message[1], x+5, y)
			y += 22
			DrawCanvasText(message[2], x+5, y)
			y += 22
			DrawCanvasText(message[3], x+5, y)
			y += 22
			DrawCanvasText(message[4], x+5, y)
		Endif
		
		Return result
	End

	Method Clear:Int(region:String="all")
		Self.drawImage = Null
		Self.name = ""
		Self.message = New String[5]
		Self.message[0] = ""
		Self.message[1] = ""
		Self.message[2] = ""
		Self.message[3] = ""
		Self.message[4] = ""
		Self.writeIndex = 0
		Self.isDraw = False
		Self.isDrawComplete = False
	End

	Method Init:Void()
		storeMap = New StringMap<Image>
		Self.Clear()
	End	
End