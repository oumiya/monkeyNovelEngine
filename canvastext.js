var GCanvas, GCanvasRC;

function initRenderContext(id)
{
	GCanvas = document.getElementById(id);
	GCanvasRC = GCanvas.getContext("2d");
}

function SetCanvasFont(fnt)
{
	if (!GCanvasRC) initRenderContext("GameCanvas");

	GCanvasRC.font = fnt;
	SetCanvasTextBaseline("top");
	SetCanvasTextAlign("left");
}

function DrawCanvasText(txt, x, y)
{
	GCanvasRC.fillText(txt, x, y);
}

function FitCanvasText(txt, x, y, maxwidth)
{
	GCanvasRC.fillText(txt, x, y, maxwidth);
}

function SetCanvasTextAlign(ta)
{
	GCanvasRC.textAlign = ta;
}

function SetCanvasTextBaseline(bl)
{
	GCanvasRC.textBaseline = bl;
}

function GetCanvasTextWidth(txt)
{
	return GCanvasRC.measureText(txt).width;
}