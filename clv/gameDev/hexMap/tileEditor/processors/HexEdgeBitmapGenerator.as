package clv.gameDev.hexMap.tileEditor.processors 
{
	import caurina.transitions.ColorMatrix;
	import clv.gameDev.hexMap.tileEditor.data.EdgeData;
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import clv.gameDev.hexMap.tileEditor.data.EdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.HexEdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.TileTypes;
	import clv.gameDev.hexMap.tileEditor.outputs.HexEdge;
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.outputs.HexeEdges;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Shape;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexEdgeBitmapGenerator 
	{
		private static const R:Number = 1.1547;
		
		private static var blur:BlurFilter 
		private static var displacementMap:DisplacementMapFilter;
		private static var colorMatrixFilter:ColorMatrixFilter;
		private static var colorMatrix:ColorMatrix;
		
		private static var colorTransform:ColorTransform
		
		public function HexEdgeBitmapGenerator() 
		{
			
		}
		
		public static function init():void
		{
			blur = new BlurFilter(0, 0, BitmapFilterQuality.HIGH);
			
			displacementMap = new DisplacementMapFilter();
			displacementMap.mapPoint = new Point(0, 0);
			displacementMap.componentX = BitmapDataChannel.RED;
			displacementMap.componentY = BitmapDataChannel.GREEN;
			displacementMap.scaleX = 100; 
			displacementMap.scaleY = 100;
			displacementMap.mode = DisplacementMapFilterMode.CLAMP;
			
			colorMatrix = new ColorMatrix();
			colorMatrix.setBrightness(0);
			colorMatrix.setContrast(0);
			
			
			colorMatrixFilter = new ColorMatrixFilter();
			colorTransform = new ColorTransform();
			
		}
		
		public static function getNewEdges():HexeEdges
		{
			/*
				types and rotations
				1 	- 10 	: 6
				10 	- 12 	: 3
				12	-	16 	: 1
			*/
				
			
			
			var i:int;
			var j:int;
			
			var es:HexeEdges = new HexeEdges();
			
			updateShapes(es);
			
			/*for (i = 0; i < 10; i++) 
			{
				for (j = 0; j < 6; j++) 
				{
					es.edges.push(makeShape(i, j));
					
				}
			}
			
			for (i = 10; i < 12; i++) 
			{
				for (j = 0; j < 3; j++) 
				{	
					es.edges.push(makeShape(i, j));
				}
			}
			
			for (i = 12; i < 16; i++) 
			{	
				es.edges.push(makeShape(i, 0));
			}*/
			
			es.hexMask = drawHex();
			
			return es;
			
		}
		
		private static function makeShape(type:int, rotation:int):HexEdge
		{
			var e:HexEdge = new HexEdge();
			
			var pw:Number = Project.data.tileWidth;
			var ph:Number = Project.data.tileWidth * R * Project.data.tileScale;
			
			e.shape = new BitmapData(pw * 3, ph * 3, false, 0x000000);
			
			var m:Matrix = new Matrix();
			
			var s:Number =  Project.data.tileWidth / HexShapeGenerator.shape.width;
			
			m.rotate(Math.PI/180 * 60 * rotation);
			m.scale(s, s * Project.data.tileScale);
			m.translate(pw * 1.5, ph * 1.5);
			
			e.shape.draw(HexShapeGenerator.shapes[type], m);
			
			e.rotation = rotation;
			e.type = type;
			
			return e;
		}
		
		public static function updateShapes(es:HexeEdges):void
		{
			var i:int;
			var j:int;
			
			es.edges.length = 0;
			
			for (i = 0; i < 10; i++) 
			{
				for (j = 0; j < 6; j++) 
				{
					es.edges.push(makeShape(i, j));
					
				}
			}
			
			for (i = 10; i < 12; i++) 
			{
				for (j = 0; j < 3; j++) 
				{	
					es.edges.push(makeShape(i, j));
				}
			}
			
			for (i = 12; i < 16; i++) 
			{	
				es.edges.push(makeShape(i, 0));
			}
			
			es.hexMask = drawHex();
			
			es.w = Project.data.tileWidth;
			es.h = Project.data.tileWidth * R * Project.data.tileScale;
			
		}
		
		public static function drawMasks(edge:EdgeData, es:HexeEdges):void
		{
			
			if (es.w != Project.data.tileWidth || es.h != Project.data.tileWidth * R * Project.data.tileScale) updateShapes(es);
			
			blur.blurX = blur.blurY = edge.blur;
			
			colorMatrix.reset();
			colorMatrix.setBrightness(edge.brightness);
			colorMatrix.setContrast(edge.contrast);
			
			colorMatrixFilter.matrix = colorMatrix.matrix;
			

			for (var j:int = 0; j < es.edges.length; j++) 
			{
				
				var e:HexEdge = es.edges[j];
				
				if (!e.mask) e.mask = new BitmapData(e.shape.width, e.shape.height, false, 0);
				
				
				if (!edge.edgeMask.getBitmapData() || !edge.edgeMask.getBitmapData().rect.equals(e.shape.rect))	
					edge.edgeMask.setBitmapData(new BitmapData(e.shape.width, e.shape.height, false, 0));
					
				if (!edge.hexMask.getBitmapData() || !edge.hexMask.getBitmapData().rect.equals(es.hexMask.rect))
					edge.hexMask.setBitmapData(es.hexMask);
				
				var edgeMask:BitmapData = edge.edgeMask.getBitmapData();
				var hexMask:BitmapData = edge.hexMask.getBitmapData();
				
				edgeMask.fillRect(e.mask.rect, 0x000000);
				edgeMask.copyPixels(e.shape, e.shape.rect, new Point());
				
				edgeMask.applyFilter(edgeMask, edgeMask.rect, new Point(), blur);
				edgeMask.applyFilter(edgeMask, edgeMask.rect, new Point(), colorMatrixFilter);
				
				
				
				if (edge.displacementMap && edge.displacementMap.bitmapData && edge.displacementMapEnabled)
				{
					var bd:BitmapData = new BitmapData(edge.displacementMap.bitmapData.width, edge.displacementMap.bitmapData.height, false, 0x808080);
					var s:Shape = new Shape();
					s.graphics.beginFill(0x808080, 1 - edge.displacementMapAmount / 100);
					s.graphics.drawRect(0, 0, edge.displacementMap.bitmapData.width, edge.displacementMap.bitmapData.height);
					s.graphics.endFill();
					bd.copyPixels(edge.displacementMap.bitmapData, edge.displacementMap.bitmapData.rect, new Point());
					bd.draw(s);
					displacementMap.mapBitmap = bd;
					edgeMask.applyFilter(edgeMask, edgeMask.rect, new Point(), displacementMap);
					bd.dispose();
				}
				
				
				e.mask.fillRect(e.mask.rect, 0x000000);
				
				for (var i:int = 0; i < edge.layers.length; i++) 
				{
					
					var l:EdgeLayer =  edge.layers[i];
					
					colorTransform.alphaMultiplier = l.alpha / 100;
					
					
					if (l is HexEdgeMask)
					{
						e.mask.draw(hexMask, null, colorTransform, l.blend);
					}
					else if (l is EdgeMask)
					{
						e.mask.draw(edgeMask, null, colorTransform, l.blend);
					}
					else
					{
						e.mask.draw(l.bitmap.bitmapData, null, colorTransform, l.blend);
					}
					
				}
			}
			
		}
		
		private static function drawHex():BitmapData
		{

			var pw:Number = Project.data.tileWidth;
			var ph:Number = Project.data.tileWidth * R * Project.data.tileScale;
			
			var b:BitmapData = new BitmapData(pw * 3, ph * 3, false, 0x000000);
			
			var m:Matrix = new Matrix();
			
			var s:Number =  Project.data.tileWidth / HexShapeGenerator.shape.width;
			
			//m.rotate(Math.PI/180 * 60 * rotation);
			m.scale(s, s * Project.data.tileScale);
			m.translate(pw * 1.5, ph * 1.5);
			
			b.draw(HexShapeGenerator.shape, m);
			
			return b;
		}
		
	}

}