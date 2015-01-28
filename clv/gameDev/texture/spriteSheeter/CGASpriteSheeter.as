package clv.gameDev.texture.spriteSheeter 
{
	import clv.gameDev.texture.ClvGraphAsset;
	import clv.gameDev.texture.ClvGraphAssetAnimation;
	import clv.gameDev.texture.ClvGraphAssetSprite;
	import com.genome2d.textures.GTextureAtlas;
	import com.genome2d.utils.GMaxRectPacker;
	import com.genome2d.utils.GPackerRectangle;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Zvir
	 */
	public class CGASpriteSheeter 
	{
		
		public function CGASpriteSheeter() 
		{
			
		}
		
		public static function makeCGA(name:String, sprites:Vector.<CGASSSprite>, animations:Vector.<CGASSAnimation>, heuristics:int = 0, padding:int = 0):ClvGraphAsset
		{
			
			var cga:ClvGraphAsset = new ClvGraphAsset();
			
			var packer:GMaxRectPacker = new GMaxRectPacker(1, 2, 4096, 4096, true, heuristics);
			
			var dict:Dictionary = new Dictionary();
			
			var sp:Vector.<CGASSSprite> = new Vector.<CGASSSprite>();
			
			for (var i:int = 0; i < sprites.length; i++)
			{
				var s:CGASSSprite = sprites[i];
				
				trim(s);
				//findDuplicates(s, sprites);
				
				if (s.copy) continue;
				
				var g:GPackerRectangle = new GPackerRectangle();
				
				g.bitmapData = s.bitmap;
				
				g.x 		= s.trimed.x;
				g.y 		= s.trimed.y;
				
				g.width 	= s.trimed.width;
				g.height 	= s.trimed.height;
				
				g.pivotX 	= 0;
				g.pivotY 	= 0;
				
				packer.packRectangle(g, padding);
				
				dict[s] = g;
				sp.push(s);
			}
			
			if (animations)
			{
				for (i = 0; i < animations.length; i++)
				{
					var a:CGASSAnimation = animations[i];
					
					for (var j:int = 0; j < a.sprites.length; j++) 
					{
						s = a.sprites[j];
					
						trim(s);
						//findDuplicates(s, sprites);
						
						if (s.copy) continue;
						
						g = new GPackerRectangle();
						
						g.bitmapData = s.bitmap;
						
						g.x 		= s.trimed.x;
						g.y 		= s.trimed.y;
						
						g.width 	= s.trimed.width;
						g.height 	= s.trimed.height;
						
						g.pivotX 	= 0;
						g.pivotY 	= 0;
						
						packer.packRectangle(g, padding);
						
						dict[s] = g;
						sp.push(s);
					}
				}
			}
			
			var area:Number = 0;
			
			for (i = 0; i < sp.length; i++)
			{
				
				s = sp[i];
				
				if (s.copy)
				{
					g = dict[s.copy];
				}
				else
				{
					g = dict[s];
				}
				
				s.result.x = g.x;
				s.result.y = g.y;
				s.result.width = g.width;
				s.result.height = g.height;
				
				area += g.width * g.height;
				
			}
			
			var b:BitmapData = new BitmapData(packer.getWidth(), packer.getHeight(), true, 0x00000000);
			
			for (i = 0; i < sp.length; i++)
			{
				s = sp[i];
				
				if (s.result.width == -1) continue;
				if (s.copy) continue;
				
				var r:Rectangle = s.result.clone();
				
				b.copyPixels(s.bitmap, s.trimed, r.topLeft);
				
			}
			
			trace(packer.getWidth(), packer.getHeight(), Number(area / (packer.getWidth() * packer.getHeight())).toFixed(2));
			
			cga.name = name.replace(/\.\w+$/g,"").replace(/ /gi, "_").replace(/-/gi, "_");
			cga.pixels = b.getPixels(b.rect);
			cga.width = b.width;
			cga.height = b.height;
			cga.transparet = b.transparent;
			
			for (i = 0; i < sprites.length; i++) 
			{
				cga.sprites.push(getCGS(sprites[i]));
			}
			
			if (animations)
			{
				for (i = 0; i < animations.length; i++) 
				{
					cga.animations.push(getCGA(animations[i]));
				}
			}
			
			return cga;
			
		}
		
		static private function getCGA(a:CGASSAnimation):ClvGraphAssetAnimation 
		{
			var aa:ClvGraphAssetAnimation = new ClvGraphAssetAnimation();
			
			aa.name = a.name;
			
			for (var i:int = 0; i < a.sprites.length; i++) 
			{
				aa.sprites.push(getCGS(a.sprites[i]));
			}
			
			return aa;
			
		}
		
		private static function trim(s:CGASSSprite):void
		{
			s.trimed = s.bitmap.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
		}
		
		private static function findDuplicates(s:CGASSSprite, sprites:Vector.<CGASSSprite>):void
		{
			if (s.copy) return;
			
			for (var i:int = 0; i < sprites.length; i++) 
			{
				var ss:CGASSSprite = sprites[i];
				
				if (!ss.copy && s.bitmap.compare(ss.bitmap) == 0)
				{
					s.copy = ss;
					return;
				}
			}
		}
		
		private static function getCGS(ss:CGASSSprite):ClvGraphAssetSprite
		{
			
			var sc:ClvGraphAssetSprite = new ClvGraphAssetSprite();
			
			sc.name				= ss.name.replace(/\.\w+$/g,"").replace(/ /gi, "_").replace(/-/gi, "_");
			
			if (ss.copy) ss = ss.copy;
			
			sc.x				= ss.result.x;
			sc.y				= ss.result.y;
			
			sc.width			= ss.result.width;
			sc.height			= ss.result.height;
			
			sc.offsetX			= -ss.trimed.x;
			sc.offsetY			= -ss.trimed.y;
			
			sc.orginalWidth		= ss.bitmap.rect.width;
			sc.orginalHeight	= ss.bitmap.rect.height;
			
			sc.pivotX			= (sc.orginalWidth - sc.width) / 2 + sc.offsetX;
			sc.pivotY			= (sc.orginalHeight - sc.height) / 2 + sc.offsetY;
			
			return sc;
		}
		
	}

}