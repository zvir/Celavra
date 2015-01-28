package clv.gui.g2d.components 
{
	import clv.gui.common.styles.ImageStyle;
	import clv.gui.common.styles.ImageStyleCrop;
	import clv.gui.common.styles.ImageStyleSize;
	import clv.gui.g2d.core.SkinG2D;
	import clv.gui.g2d.display.G2DGuiBody;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.node.factory.GNodeFactory;
	import com.genome2d.textures.GTexture;
	import flash.geom.Rectangle;
	import zvr.zvrG2D.ZvrGSprite;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class SpriteComponetnSkin extends SkinG2D
	{
		private var _sprite:ZvrGSprite;
		private var _crop:String;
		
		private var _maskRect:Rectangle;
		
		private var _scale:Number = 1;
		
		private var _size:String;
		
		public function SpriteComponetnSkin() 
		{
			
		}
		
		override protected function registerStyles():void 
		{
			registerStyle(ImageStyle.CROP	, setCrop);
			registerStyle(ImageStyle.IMAGE	, setImage);
			registerStyle(ImageStyle.ALPHA	, setApha);
			registerStyle(ImageStyle.SCALE	, setScale);
			registerStyle(ImageStyle.SIZE	, setSize);
			registerStyle(ImageStyle.COLOR	, setColor);
		}
		
		override protected function setStyles():void 
		{
			setStyle(ImageStyle.CROP, ImageStyleCrop.NO_SCALE);
			setStyle(ImageStyle.ALPHA, 1);
			setStyle(ImageStyle.COLOR, 0xffffff);
			setStyle(ImageStyle.SCALE, 1);
			setStyle(ImageStyle.SIZE, ImageStyleSize.IMAGE);
		}
		
		override protected function create():void 
		{
			super.create();
			
			_sprite = _skinNode.addComponent(ZvrGSprite) as ZvrGSprite;
			_maskRect = new Rectangle();
			
		}
		
		override public function preUpdate():void 
		{
			super.preUpdate();
			
			if (_crop == ImageStyleCrop.NO_SCALE && _sprite.texture && _size == ImageStyleSize.IMAGE)
			{
				if (_component.width != _sprite.texture.frameWidth * _scale) _component.width = _sprite.texture.frameWidth * _scale;
				if (_component.height != _sprite.texture.frameHeight * _scale) _component.height = _sprite.texture.frameHeight * _scale;
			}
		}
		
		override public function updateBounds():void 
		{
			super.updateBounds();
			
			if (!positionDirty && !sizeDirty) return;
			
			if (sizeDirty)
			{
				if (_crop == ImageStyleCrop.NO_SCALE)
				{
					_skinNode.transform.scaleX = _scale;
					_skinNode.transform.scaleY = _scale;
					
					_sprite.maskRect = null;
					
				}
				else if (_crop == ImageStyleCrop.FILL)
				{
					_skinNode.transform.scaleX = _component.bounds.width / _sprite.texture.frameWidth;
					_skinNode.transform.scaleY = _component.bounds.height / _sprite.texture.frameHeight;
					
					_sprite.maskRect = null;
				}
				else
				{
					var rc:Number = _component.bounds.width / _component.bounds.height;
					var ri:Number = _sprite.texture.frameWidth / _sprite.texture.frameHeight;
					
					if (_crop == ImageStyleCrop.INSIDE)
					{
						
						if (rc < ri)
						{
							_sprite.node.transform.scaleX = _sprite.node.transform.scaleY = _component.bounds.width / _sprite.texture.frameWidth;
						}
						else
						{
							_sprite.node.transform.scaleX = _sprite.node.transform.scaleY = _component.bounds.height / _sprite.texture.frameHeight;
						}
						
					}
					else if (_crop == ImageStyleCrop.OUTSIDE)
					{
						if (rc > ri)
						{
							_sprite.node.transform.scaleX = _sprite.node.transform.scaleY = _component.bounds.width / _sprite.texture.frameWidth;
						}
						else
						{
							_sprite.node.transform.scaleX = _sprite.node.transform.scaleY = _component.bounds.height / _sprite.texture.frameHeight;
						}
						
					}
					
					
					
					_maskRect.x = -_component.bounds.width / 2;
					_maskRect.y = -_component.bounds.height / 2;
					
					_maskRect.width = _component.bounds.width;
					_maskRect.height = _component.bounds.height;
					
					_sprite.maskRect = _maskRect;
					
				}
				
				_skinNode.transform.scaleX *= _component.appScale;
				_skinNode.transform.scaleY *= _component.appScale;
			}
			
			/*
			var w:Number = _crop == ImageStyleCrop.NO_SCALE ? _component.bounds.width * _scale : _component.bounds.width;
			var h:Number = _crop == ImageStyleCrop.NO_SCALE ? _component.bounds.height * _scale : _component.bounds.height;
			*/
			
			_skinNode.transform.x = int(_component.bounds.x + _component.bounds.width / 2);
			_skinNode.transform.y = int(_component.bounds.y + _component.bounds.height / 2);
		}
		
		private function setCrop():void 
		{
			_crop = getStyle(ImageStyle.CROP);
			sizeDirty = true;
		}
		
		private function setImage():void 
		{
			_sprite.texture = getStyle(ImageStyle.IMAGE) as GTexture;
		}
		
		private function setApha():void 
		{
			_sprite.node.transform.alpha = getStyle(ImageStyle.ALPHA);
		}
		
		private function setScale():void 
		{
			_scale = getStyle(ImageStyle.SCALE);
			sizeDirty = true;
		}
		
		private function setSize():void 
		{
			_size =  getStyle(ImageStyle.SIZE);
			sizeDirty = true;
		}
		
		private function setColor():void 
		{
			_sprite.node.transform.color = getStyle(ImageStyle.COLOR);
		}
	}
}