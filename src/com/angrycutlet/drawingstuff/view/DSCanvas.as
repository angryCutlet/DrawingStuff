package com.angrycutlet.drawingstuff.view
{
	import com.angrycutlet.drawingstuff.data.DSTools;
	import com.angrycutlet.drawingstuff.data.DSUnits;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.events.FlexEvent;
	
	import spark.core.SpriteVisualElement;
	
	public class DSCanvas extends SpriteVisualElement
	{
		private var units:String = DSUnits.INCHES;
		private var selectedTool:String = DSTools.RECTANGLE;
		
		//drawings
		private var rect:DSRectangle;
		
		public function DSCanvas()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onCreationComplete);
		}
		
		protected function onCreationComplete(event:Event):void
		{
			this.graphics.beginFill( 0xFF0000, 0.5 );
			this.graphics.drawRect(0,0, width, height);
			this.graphics.endFill();
			this.addEventListener(MouseEvent.CLICK, onMouseClicked );
		}		
		
		
		protected function onMouseClicked(event:MouseEvent):void
		{
			switch ( selectedTool )
			{
				case DSTools.RECTANGLE:
					drawRect(this.mouseX, this.mouseY);
					break;
			}
		}
		
		private function drawRect(startX:Number, startY:Number):void
		{
			if ( rect == null ) rect = new DSRectangle();
			var p:Point = new Point(startX, startY);
			rect.drawPoint( p );
			this.addChild( rect );
		}
		
	}
}