package clv.gameDev.hexMap.tileEditor.processors 
{
	import _Map.Map_Impl_;
	import flash.display.Graphics;
	import flash.display.Shape;
	import zvr.zvrTools.ZvrPnt;
	import zvr.zvrTools.ZvrPntMath;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexShapeGenerator 
	{
		
		public static const shapes:Vector.<Shape> = new Vector.<Shape>();
		
		public static var shape:Shape;
		
		private static var corners:Vector.<ZvrPnt> = new Vector.<ZvrPnt>();
		private static var cornersB:Vector.<ZvrPnt> = new Vector.<ZvrPnt>();
		private static var centers:Vector.<ZvrPnt> = new Vector.<ZvrPnt>();
		private static var centersB:Vector.<ZvrPnt> = new Vector.<ZvrPnt>();
		private static var start:Vector.<ZvrPnt> = new Vector.<ZvrPnt>();
		private static var ends:Vector.<ZvrPnt> = new Vector.<ZvrPnt>();
		
		public static function init() 
		{
			generatePoints();
			generateShapes();
		}
		
		private static function generateShapes():void 
		{
			
			shape = getHexShape();
			
			for (var i:int = 0; i < 16; i++) 
			{
				makeHex(i);
			}
		}
		
		private static function makeHex(type:int, startPoint:int = 0):Shape
		{
			
			var s:Shape;
			
			if (type < 10)
			{
				s = makeStandartHex(type, startPoint);
				
			}
			else if (type == 10)
			{
				s = getShape();
				shapes[type] = s
				
				//drawSpline(startPoint, 1, s);
				
				//drawSpline(getIndex(startPoint + 3), 1, s);
				
				s.graphics.beginFill(0xFFFFFF, 1);
				
				s.graphics.moveTo(start[getIndex(startPoint + 0)].x, start[getIndex(startPoint + 0)].y);
				s.graphics.lineTo(centers[getIndex(startPoint + 0)].x, centers[getIndex(startPoint + 0)].y);
				s.graphics.lineTo(centers[getIndex(startPoint + 1)].x, centers[getIndex(startPoint + 1)].y);
				s.graphics.lineTo(ends[getIndex(startPoint + 1)].x, ends[getIndex(startPoint + 1)].y);
				
				s.graphics.lineTo(cornersB[getIndex(startPoint + 2)].x, cornersB[getIndex(startPoint + 2)].y);
				s.graphics.lineTo(cornersB[getIndex(startPoint + 3)].x, cornersB[getIndex(startPoint + 3)].y);
				
				
				s.graphics.lineTo(start[getIndex(startPoint + 3)].x, start[getIndex(startPoint + 3)].y);
				s.graphics.lineTo(centers[getIndex(startPoint + 3)].x, centers[getIndex(startPoint + 3)].y);
				s.graphics.lineTo(centers[getIndex(startPoint + 4)].x, centers[getIndex(startPoint + 4)].y);
				s.graphics.lineTo(ends[getIndex(startPoint + 4)].x, ends[getIndex(startPoint + 4)].y);
				
				s.graphics.lineTo(cornersB[getIndex(startPoint + 5)].x, cornersB[getIndex(startPoint + 5)].y);
				s.graphics.lineTo(cornersB[getIndex(startPoint + 0)].x, cornersB[getIndex(startPoint + 0)].y);
				
				s.graphics.endFill();
				
			}
			else if (type == 11)
			{
				s = getShape();
				shapes[type] = s
				
				
				s.graphics.beginFill(0xFFFFFF, 1);
				drawSpline(getIndex(startPoint), 1, s);
				s.graphics.lineTo(cornersB[getIndex(startPoint + 1)].x, cornersB[getIndex(startPoint + 1)].y);
				s.graphics.endFill();
				
				s.graphics.beginFill(0xFFFFFF, 1);
				drawSpline(getIndex(startPoint + 3), 1, s);
				s.graphics.lineTo(cornersB[getIndex(startPoint + 4)].x, cornersB[getIndex(startPoint + 4)].y);
				s.graphics.endFill();
				
			}
			else if (type == 12)
			{
				s = getShape();
				shapes[type] = s
				
			}
			else if (type == 13)
			{
				s = getFull();
				shapes[type] = s
				
			}
			else if (type == 14)
			{
				s = getCircle();
				shapes[type] = s
				
			}
			else if (type == 15)
			{
				s = getCircleNeg();
				shapes[type] = s
				
			}
			
			return s;
		
		}
		
		private static function makeStandartHex(type:int, startPoint:int):Shape
		{
			
			var k:int = type + 1;
			
			if (type >= 5)
			{
				var neg:Boolean = true;
				k -= 5;
			}
			
			var s:Shape = getShape();
			
			shapes[type] = s
			
			s.graphics.beginFill(0xFFFFFF, 1);
			
			drawSpline(startPoint, k, s);
			
			if (!neg)
			{
				
				for (var j:int = 0; j < 6 - k; j++)
				{
					var ci:int = getIndex(k + j + 1 + startPoint);
					s.graphics.lineTo(cornersB[ci].x, cornersB[ci].y);
				}
				
				s.graphics.lineTo(start[startPoint].x, start[startPoint].y);
				s.graphics.lineTo(centers[startPoint].x, centers[startPoint].y);
				s.graphics.endFill();
				
			}
			else
			{
				
				for (var j:int = k; j > 0; j--)
				{
					var ci:int = getIndex(j + startPoint);
					s.graphics.lineTo(cornersB[ci].x, cornersB[ci].y);
				}
				
				s.graphics.lineTo(centersB[startPoint].x, centersB[startPoint].y);
				s.graphics.lineTo(start[startPoint].x, start[startPoint].y);
				s.graphics.lineTo(centers[startPoint].x, centers[startPoint].y);
				s.graphics.endFill();
			}
			
			
			return s;
		
		}
		
		private static function getIndex(i:int):int
		{
			if (i < 0)
				i = -i % 6;
			if (i >= 6)
				i = i % 6;
			return i;
		}
		
		private static function drawEdge(s:int, e:int, sp:Shape):void
		{
			
			var g:Graphics = sp.graphics;
			
			g.lineStyle(0, 0xFFFFFF, 0);
			
			g.moveTo(centers[s].x, centers[s].y);
			g.lineTo(centers[e].x, centers[e].y);
		
		}
		
		private static function drawSpline(s:int, l:int, sp:Shape):void
		{
			
			var g:Graphics = sp.graphics;
			
			g.lineStyle(0, 0x000000, 0);
			
			if (l > 1)
			{
				g.moveTo(start[s].x, start[s].y);
				
				//dot(sp, start[s].x, start[s].y, 10000, 0xFD0000, 1, 4);
				
				for (var i:int = s; i <= s + l; i++)
				{
					
					if (i != s)
					{
						var pi:int = getIndex(i - 1);
						var pp:ZvrPnt = centers[pi];
					}
					else
					{
						pp = start[s];
					}
					if (i != s + l)
					{
						pi = getIndex(i + 1);
						var pn:ZvrPnt = centers[pi];
					}
					
					drawSpline2(g, centers[getIndex(i)], pp, pn);
				}
				
				g.lineTo(ends[getIndex(s + l)].x, ends[getIndex(s + l)].y);
				
			}
			else
			{
				
				
				g.moveTo(start[s].x, start[s].y);
				g.lineTo(centers[s].x, centers[s].y);
				g.lineTo(centers[getIndex(s + l)].x, centers[getIndex(s + l)].y);
				g.lineTo(ends[getIndex(s + l)].x, ends[getIndex(s + l)].y);
				
			}
		
		}
		
		private static function getCircleNeg():Shape
		{
			var s:Shape = getShape();
			
			s.graphics.beginFill(0xFFFFFF);
			
			for (var i:int = 0; i < 6; i++)
			{
				var p:ZvrPnt = cornersB[i];
				
				if (i == 0)
				{
					s.graphics.moveTo(p.x, p.y);
				}
				else
				{
					s.graphics.lineTo(p.x, p.y);
				}
			}
			
			s.graphics.lineTo(cornersB[0].x, cornersB[0].y);
			
			s.graphics.drawCircle(0, 0, 45);
			s.graphics.endFill();
			return s;
		}
		
		private static function getCircle():Shape
		{
			var s:Shape = getShape();
			s.graphics.beginFill(0xFFFFFF);
			s.graphics.drawCircle(0, 0, 45);
			s.graphics.endFill();
			return s;
		}
		
		private static function getFull():Shape
		{
			var s:Shape = getShape();
			s.graphics.beginFill(0xFFFFFF);
			
			for (var i:int = 0; i < 6; i++)
			{
				var p:ZvrPnt = cornersB[i];
				
				if (i == 0)
				{
					s.graphics.moveTo(p.x, p.y);
				}
				else
				{
					s.graphics.lineTo(p.x, p.y);
				}
			}
			
			s.graphics.lineTo(cornersB[0].x, cornersB[0].y);
			
			s.graphics.endFill();
			
			return s;
		}
		
		private static function getHexShape():Shape
		{
			var s:Shape = getShape();
			s.graphics.beginFill(0xFFFFFF);
			
			for (var i:int = 0; i < 6; i++)
			{
				var p:ZvrPnt = corners[i];
				
				if (i == 0)
				{
					s.graphics.moveTo(p.x, p.y);
				}
				else
				{
					s.graphics.lineTo(p.x, p.y);
				}
			}
			
			s.graphics.lineTo(corners[0].x, corners[0].y);
			
			s.graphics.endFill();
			
			return s;
		}
		
		private static function getShape():Shape
		{
			return new Shape();
		}
		
		private static function generatePoints():void
		{
			for (var i:int = 0; i < 6; i++)
			{
				var p:ZvrPnt = ZvrPntMath.getPolar(60, 60 * i + 30);
				var p2:ZvrPnt = ZvrPntMath.getPolar(120, 60 * i + 30);
				
				corners.push(p);
				cornersB.push(p2);
				
				if (i != 0)
				{
					var c:ZvrPnt = new ZvrPnt();
					var c2:ZvrPnt = new ZvrPnt();
					
					ZvrPntMath.setBetween(c, p, corners[i - 1], 0.5);
					ZvrPntMath.setBetween(c2, p2, cornersB[i - 1], 0.5);
					
					centers.push(c);
					centersB.push(c2);
					
				}
			}
			
			c = new ZvrPnt();
			ZvrPntMath.setBetween(c, p, corners[0], 0.5);
			centers.push(c);
			
			c2 = new ZvrPnt();
			ZvrPntMath.setBetween(c2, p2, cornersB[0], 0.5);
			centersB.push(c2);
			
			for (var j:int = 0; j < 6; j++) 
			{
				var p:ZvrPnt = centers[j].clone();
				ZvrPntMath.polar(p, 60, 60 * j);
				
				start.push(p);
				
				p = centers[j].clone();
				ZvrPntMath.polar(p, 60, 60 * j + 180 - 60);
				
				ends.push(p);
			}
		}
		
		private static function drawSpline2(target:Graphics, p:ZvrPnt, prev:ZvrPnt = null, next:ZvrPnt = null):void
		{
			if (!prev && !next)
			{
				return; //cannot draw a 1-dimensional line, ie a line requires at least two points
			}
			
			var mPrev:ZvrPnt; //mid-point of the previous point and the target point
			var mNext:ZvrPnt; //mid-point of the next point and the target point
			
			if (prev)
			{
				mPrev = new ZvrPnt((p.x + prev.x) / 2, (p.y + prev.y) / 2);
			}
			if (next)
			{
				mNext = new ZvrPnt((p.x + next.x) / 2, (p.y + next.y) / 2);
				if (!prev)
				{
					//This is the first line point, only draw to the next point's mid-point
					target.moveTo(p.x, p.y);
					target.lineTo(mNext.x, mNext.y);
					return;
				}
			}
			else
			{
				//This is the last line point, finish drawing from the previous mid-point
				//target.moveTo(mPrev.x, mPrev.y);
				target.lineTo(p.x, p.y);
				return;
			}
			//draw from mid-point to mid-point with the target point being the control point.
			//Note, the line will unfortunately not pass through the actual vertex... I want to solve this
			//target.moveTo(mPrev.x, mPrev.y);
			target.curveTo(p.x, p.y, mNext.x, mNext.y);
		}
		
	}

}