package com.angrycutlet.drawingstuff.view
{
	import com.angrycutlet.drawingstuff.DSToolEvents;
	import com.angrycutlet.drawingstuff.data.DSTools;
	import com.angrycutlet.drawingstuff.data.DSUnits;
	import com.angrycutlet.drawingstuff.interfaces.IDSDrawable;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.events.FlexEvent;
	
	import spark.core.SpriteVisualElement;
	
	public class DSCanvas extends SpriteVisualElement
	{
		private var units:String = DSUnits.INCHES;
		private var _selectedTool:String = null;
		private var _selectedToolInstance:IDSDrawable = null;
		private var isDrawing:Boolean = false;
		
		private var _fillColor:uint = 0x000000;
		private var _strokeColor:uint = 0xFF0000;
		private var _opacity:Number = 1;
		
		public function DSCanvas()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onCreationComplete);
			
		}
		
		protected function onKeyboardPress(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if  ( event.keyCode == Keyboard.ESCAPE && _selectedToolInstance != null )
			{
				_selectedToolInstance.killSelf();
				_selectedTool = null;
				_selectedToolInstance = null;
			}
			
		}
		
		protected function onCreationComplete(event:Event):void
		{
			
			this.graphics.beginFill( 0xFFFFFF, 0.5 );
			this.graphics.drawRect(0,0, width, height);
			this.graphics.endFill();
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardPress );
		}		
		
		
		protected function onFinishedDrawing(event:Event):void
		{
			selectedTool = _selectedTool;
		}

		public function get fillColor():uint
		{
			return _fillColor;
		}

		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}

		public function get strokeColor():uint
		{
			return _strokeColor;
		}

		public function set strokeColor(value:uint):void
		{
			_strokeColor = value;
		}

		public function get opacity():Number
		{
			return _opacity;
		}

		public function set opacity(value:Number):void
		{
			_opacity = value;
		}

		public function get selectedTool():String
		{
			return _selectedTool;
		}
		
		public function set selectedTool(value:String):void
		{
			if ( value == null ) 
			{
				_selectedTool = '';
				return;
			}
			if ( _selectedTool != value && _selectedToolInstance != null )
			{
				_selectedToolInstance.killSelf();
				_selectedToolInstance = null;
			}
			_selectedTool = value;
			switch ( _selectedTool )
			{
				case DSTools.RECTANGLE:
					var rect:DSRectangle = new DSRectangle(fillColor, strokeColor, opacity);
					_selectedToolInstance = rect;
					rect.addEventListener(DSToolEvents.FINISHED_DRAWING, onFinishedDrawing);
					this.addChild( rect );
					break;
				case DSTools.LINE:
					var line:DSLine = new DSLine(fillColor, strokeColor, opacity);
					_selectedToolInstance = line;
					line.addEventListener(DSToolEvents.FINISHED_DRAWING, onFinishedDrawing);
					this.addChild(line);
					break;
			}
			
		}

	}
}