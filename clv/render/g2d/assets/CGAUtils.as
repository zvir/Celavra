package clv.render.g2d.assets
{
	import clv.gameDev.texture.ClvGraphAsset;
	import clv.gameDev.texture.ClvGraphAssetAnimation;
	import clv.gameDev.texture.ClvGraphAssetChar;
	import clv.gameDev.texture.ClvGraphAssetFont;
	import clv.gameDev.texture.ClvGraphAssetSprite;
	import com.genome2d.context.IContext;
	import com.genome2d.error.GError;
	import com.genome2d.Genome2D;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureAtlas;
	import com.genome2d.textures.GTextureSourceType;
	import com.genome2d.textures.GTextureType;
	import com.genome2d.textures.GTextureUtils;
	import flash.display.BitmapData;
	
	VERSION::air
	{
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
	}
	
	
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class CGAUtils
	{
		static public var g2d_context:IContext;
		
		static private var registeredClassAliases:Boolean;
		
		public function CGAUtils()
		{
		
		}
		
		VERSION::air
		static public function loadFromFile(file:File):ClvGraphAsset
		{
			if (!registeredClassAliases)
			{
				registerClassAliases();
			}
			
			if (!file.exists) return null;
			
			var stram:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			
			stram.open(file, FileMode.READ);
			stram.readBytes(bytes);
			
			var cga:ClvGraphAsset = bytes.readObject() as ClvGraphAsset;
			
			return cga;
		
		}
		
		VERSION::air
		public static function loadToGT(file:File):GTextureAtlas
		{
			var cga:ClvGraphAsset = loadFromFile(file);
			
			if (!cga) return null;
			
			return createFromCGA(cga);
			
		}
		
		static private function registerClassAliases():void
		{
			registeredClassAliases = true;
			registerClassAlias("clv.gameDev.texture.ClvGraphAsset", ClvGraphAsset);
			registerClassAlias("clv.gameDev.texture.ClvGraphAssetSprite", ClvGraphAssetSprite);
			registerClassAlias("clv.gameDev.texture.ClvGraphAssetFont", ClvGraphAssetFont);
			registerClassAlias("clv.gameDev.texture.ClvGraphAssetAnimation", ClvGraphAssetAnimation);
			registerClassAlias("clv.gameDev.texture.ClvGraphAssetChar", ClvGraphAssetChar);
		
		}
		
		static public function createFromCGA(cga:ClvGraphAsset):GTextureAtlas
		{
			if (!GTextureUtils.isValidTextureSize(cga.width) || !GTextureUtils.isValidTextureSize(cga.height))
				throw new GError("Atlas bitmap needs to have power of 2 size.");
			
			if (!g2d_context) g2d_context = Genome2D.getInstance().getContext();
			
			if (GTextureAtlas.getTextureAtlasById(cga.name))
			{
				return GTextureAtlas.getTextureAtlasById(cga.name);
			}
			
			var p_bitmapData:BitmapData = new BitmapData(cga.width, cga.height, cga.transparet);
			
			p_bitmapData.setPixels(p_bitmapData.rect, cga.pixels);
			
			var textureAtlas:GTextureAtlas = new GTextureAtlas(g2d_context, cga.name, GTextureSourceType.BITMAPDATA, p_bitmapData, p_bitmapData.rect, "bgra", 1, null);
			
			for (var i:int = 0; i < cga.sprites.length; ++i)
			{
				var sc:ClvGraphAssetSprite = cga.sprites[i];
				//textureAtlas.addSubTexture(sc.name, new Rectangle(sc.x, sc.y, sc.width, sc.height), sc.pivotX, sc.pivotY, sc.width, sc.height);
				textureAtlas.addSubTexture(sc.name, new Rectangle(sc.x, sc.y, sc.width, sc.height), sc.offsetX, sc.offsetY, sc.orginalWidth, sc.orginalHeight);
			}
			
			for (i = 0; i < cga.animations.length; ++i)
			{
				var ac:ClvGraphAssetAnimation = cga.animations[i];
				
				for (var j:int = 0; j < ac.sprites.length; j++)
				{
					sc = ac.sprites[j];
					//textureAtlas.addSubTexture(sc.name, new Rectangle(sc.x, sc.y, sc.width, sc.height), sc.pivotX, sc.pivotY, sc.width, sc.height);
					textureAtlas.addSubTexture(sc.name, new Rectangle(sc.x, sc.y, sc.width, sc.height), sc.offsetX, sc.offsetY, sc.orginalWidth, sc.orginalHeight);
				}
				
			}
			
			textureAtlas.invalidateNativeTexture(false);
			
			return textureAtlas;
		}
		
		public static function getSpriteBitmapData(cga:ClvGraphAsset, s:ClvGraphAssetSprite):BitmapData
		{
			if (!cga || !s) return null;
			
			var b:BitmapData = new BitmapData(s.orginalWidth, s.orginalHeight, cga.transparet, 0x00000000);
			b.copyPixels(cga.getBitmap(), new Rectangle(s.x, s.y, s.width, s.height), new Point(-s.offsetX, -s.offsetY));
			return b;
		}
		
		static public function loadFromEmbedded(cgaClass:Class):ClvGraphAsset 
		{
			if (!registeredClassAliases)
			{
				registerClassAliases();
			}
			
			var bytes:ByteArray = new cgaClass;
			var cga:ClvGraphAsset = bytes.readObject() as ClvGraphAsset;
			
			return cga;
			
		}
		
	}

}