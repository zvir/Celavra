package clv.gameDev.hexMap.editorUI 
{
	import clv.genome2d.components.renderables.GHexMap;
	import clv.genome2d.components.renderables.HexMapLayer;
	import clv.gameDev.hexMap.MapEditor;
	import clv.games.theFew.gui.components.button.ToggleButton;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import tests.MapDict;
	import zvr.zvrGUI.components.minimalDark.ButtonMD;
	import zvr.zvrGUI.components.minimalDark.InputMD;
	import zvr.zvrGUI.components.minimalDark.LabelMD;
	import zvr.zvrGUI.components.minimalDark.ToggleButtonMD;
	import zvr.zvrGUI.core.relays.ZvrSwitchGroup;
	import zvr.zvrGUI.core.ZvrAutoSize;
	import zvr.zvrGUI.core.ZvrGroup;
	import zvr.zvrGUI.core.ZvrWindow;
	import zvr.zvrGUI.events.ZvrLabelEvent;
	import zvr.zvrGUI.events.ZvrSelectedEvent;
	import zvr.zvrGUI.layouts.ZvrHorizontalLayout;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EditorUI extends ZvrGroup
	{
		
		private var save		:ButtonMD;
		private var toBMP		:ButtonMD;
		private var toAllBMP	:ButtonMD;
		private var fromBMP		:ButtonMD;
		private var processAll	:ButtonMD;
		
		private var layers:Vector.<ToggleButtonMD> = new Vector.<ToggleButtonMD>();
		
		private var layerName	:InputMD
		
		private var _editor:MapEditor;
		private var _mapDict:MapDict;
		private var _map:GHexMap;
		
		
		
		public function EditorUI(mapDict:MapDict, editor:MapEditor, map:GHexMap) 
		{
			_map = map;
			_mapDict = mapDict;
			_editor = editor;
			
			setLayout(ZvrVerticalLayout);
			ZvrVerticalLayout(layout).gap = 3;
			
			var swichGroup:ZvrSwitchGroup = new ZvrSwitchGroup();
			
			swichGroup.setLayout(ZvrHorizontalLayout);
			ZvrHorizontalLayout(swichGroup.layout).gap = 3;
			swichGroup.autoSize = ZvrAutoSize.CONTENT;
			
			addChild(swichGroup);
			
			for (var i:int = 0; i < _mapDict.mocups.length; i++) 
			{
				var b:ToggleButtonMD = new ToggleButtonMD();
				
				b.label.text = i.toString();
				
				swichGroup.addChild(b);
				
				layers.push(b);
			}
			
			swichGroup.addEventListener(ZvrSelectedEvent.SELECTED_CHANGE, layerChange);
			
			var g:ZvrGroup = new ZvrGroup();
			g.setLayout(ZvrHorizontalLayout);
			ZvrHorizontalLayout(g.layout).gap = 3;
			
			autoSize = ZvrAutoSize.CONTENT;
			g.top = 10;
			g.autoSize = ZvrAutoSize.CONTENT;
			//g.right = 0;
			
			layerName = new InputMD();
			layerName.labelAutoSize = false;
			layerName.height = 16;
			layerName.width = 120;
			layerName.addEventListener(ZvrLabelEvent.TEXT_CHANGE, layerNameChange);
			addChild(layerName);
			
			save = new ButtonMD();
			save.label.text = "Save";
			
			g.addChild(save);
			
			
			toBMP = new ButtonMD();
			toBMP.label.text = "Exp";
			
			g.addChild(toBMP);
			
			toAllBMP = new ButtonMD();
			toAllBMP.label.text = "ExpAll";
			
			g.addChild(toAllBMP);
			
			fromBMP = new ButtonMD();
			fromBMP.label.text = "Imp";
			
			g.addChild(fromBMP);
			
			processAll = new ButtonMD();
			processAll.label.text = "Process All";
			g.addChild(processAll);
			
			addChild(g);
			
			save.addEventListener(MouseEvent.CLICK, saveClick);
			fromBMP.addEventListener(MouseEvent.CLICK, fromBMPClick);
			toBMP.addEventListener(MouseEvent.CLICK, toBMPClick);
			toAllBMP.addEventListener(MouseEvent.CLICK, toAllBMPClick);
			processAll.addEventListener(MouseEvent.CLICK, processAllClick);
			
		}
		
		private function processAllClick(e:MouseEvent):void 
		{
			_map.process();
		}
		
		private function layerNameChange(e:ZvrLabelEvent):void 
		{
			_mapDict.mocups[_editor.selectedLayer].name = e.component.text; 
		}
		
		private function toAllBMPClick(e:MouseEvent):void 
		{
			_editor.toAllBMP();
		}
		
		private function toBMPClick(e:MouseEvent):void 
		{
			_editor.toBMP();
		}
		
		private function fromBMPClick(e:MouseEvent):void 
		{
			_editor.fromBMPClick();
		}
		
		private function saveClick(e:MouseEvent):void 
		{
			for (var i:int = 0; i < _mapDict.mocups.length; i++) 
			{
				HexMapLayer.saveFile(File.applicationDirectory.nativePath + "/assets/maps/battleOfBritain/" + i + ".hml", _mapDict.mocups[i]);
			}
		}
		
		private function layerChange(e:ZvrSelectedEvent):void 
		{
			
			if (!e.selected) return;
			
			var i:int = layers.indexOf(e.component as ToggleButtonMD);
			
			_editor.selectedLayer = i;
			
			trace(i);
			
			if (_mapDict.mocups[i].name != null ) 
			{
				layerName.text = _mapDict.mocups[i].name;
			}
			else
			{
				layerName.text = "";
			}
			
		}
		
	}

}