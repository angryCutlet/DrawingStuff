package com.angrycutlet.drawingstuff.view
{
	import com.angrycutlet.drawingstuff.DSToolEvents;
	import com.angrycutlet.drawingstuff.interfaces.IDSDrawable;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.core.SpriteVisualElement;
	
	public class DSLine extends SpriteVisualElement implements IDSDrawable
	{
		private var _isDrawing:Boolean = false;
		private var _isFinished:Boolean = false;
		private var isSelected:Boolean = false;
		private var points:Vector.<Point>;
		
		private var fillColor:uint;
		private var strokeColor:uint;
		private var opacity:Number;
		
		public function DSLine(fillColor:uint=0x000000, strokeColor:uint=0x000000, opacity:Number=1)
		{
			super();
			this.fillColor = fillColor;
			this.strokeColor = strokeColor;
			this.opacity = opacity;
			// sets the origin point
			this.addEventListener( Event.ADDED, initTool );
		}
		
		protected function initTool(event:Event):void
		{
			this.parent.addEventListener(MouseEvent.MOUSE_DOWN, draw);
		}		
		
		
		public function draw(event:MouseEvent):void 
		{
			if (!isDrawing)
			{
				points = new Vector.<Point>();
				points.push(new Point(event.localX, event.localY));
				this.parent.removeEventListener(MouseEvent.MOUSE_DOWN, draw);
				this.parent.addEventListener(MouseEvent.MOUSE_UP, draw);
				this.parent.addEventListener(MouseEvent.MOUSE_MOVE, draw );
				_isDrawing = true;
				
			}
			this.graphics.clear();
			// point 2
			points[1] = new Point( event.localX, event.localY );
			graphics.beginFill( fillColor, opacity );
			graphics.lineStyle(1, strokeColor, opacity);
			graphics.moveTo(points[0].x, points[0].y);
			graphics.lineTo(points[0].x, points[0].y);
			graphics.lineTo(points[1].x, points[1].y);
			graphics.endFill();
			
			if ( isDrawing && event.type == MouseEvent.MOUSE_UP )
			{
				this.parent.removeEventListener(MouseEvent.MOUSE_UP, draw);
				this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, draw );
				_isFinished = true;
				sendEvent( DSToolEvents.FINISHED_DRAWING );
			}
		}
		
		private function sendEvent(event:String):void 
		{
			this.dispatchEvent( new Event( event, true ));
		}
		
		public function killSelf():void 
		{
			if ( !isDrawing && !_isFinished ) this.parent.removeEventListener(MouseEvent.MOUSE_DOWN, draw);
			if ( isDrawing && !_isFinished )
			{
				graphics.clear();
				this.parent.removeEventListener(MouseEvent.MOUSE_UP, draw);
				this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, draw );
				parent.removeChild(this);
			}
		}
		
		public function get isDrawing():Boolean
		{
			return _isDrawing;
		}
		
	}
}