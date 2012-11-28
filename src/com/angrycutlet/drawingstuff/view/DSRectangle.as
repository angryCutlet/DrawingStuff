package com.angrycutlet.drawingstuff.view
{
	import com.angrycutlet.drawingstuff.DSToolEvents;
	import com.angrycutlet.drawingstuff.interfaces.IDSDrawable;
	import com.angrycutlet.drawingstuff.view.graphics.DSBaseGraphics;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;
	
	[Event(name="FINISHED_DRAWING", type="flash.events.Event")]
	
	public class DSRectangle extends DSBaseGraphics implements IDSDrawable
	{
		private var isSelected:Boolean = false;
		private var _isDrawing:Boolean = false;
		private var _isFinished:Boolean = false;
		private var points:Vector.<Point>;
		
		private var fillColor:uint;
		private var strokeColor:uint;
		private var opacity:Number;
		
		private var isOriginPoint:Boolean = true;
		
		public function DSRectangle(fillColor:uint=0x000000, strokeColor:uint=0x000000, opacity:Number=1)
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
			this.parent.addEventListener(MouseEvent.CLICK, draw);
		}		
		
		public function draw(event:MouseEvent):void 
		{
			if ( !_isDrawing && event.type != MouseEvent.CLICK ) return;
			if ( !_isDrawing && event.type == MouseEvent.CLICK )
			{
				_isDrawing = true;
				points = new Vector.<Point>();
				points.push( new Point(event.localX, event.localY) );
				this.parent.addEventListener(MouseEvent.MOUSE_MOVE, draw );
				return;
			}
			this.graphics.clear();
			points[1] = new Point( event.localX, event.localY );
			var tempRect:Rectangle = calcRect(points);
			this.graphics.beginFill( fillColor, opacity);
			this.graphics.drawRect( tempRect.x, tempRect.y, tempRect.width, tempRect.height );
			this.graphics.endFill();
			if ( event.type == MouseEvent.CLICK && _isDrawing )
			{
				_isDrawing = false;
				_isFinished = true;
				this.parent.removeEventListener(MouseEvent.CLICK, draw);
				this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, draw );
				sendEvent( DSToolEvents.FINISHED_DRAWING );
			}
		}
		
		
		private function sendEvent(event:String):void 
		{
			this.dispatchEvent( new Event( event, true ));
		}
		
		private function calcRect(points:Vector.<Point>):Rectangle 
		{
			var rect:Rectangle = new Rectangle();
			var x1:int = points[0].x;
			var x2:int = points[1].x;
			var y1:int = points[0].y;
			var y2:int = points[1].y;
			
			var fw:int = ( x2 < x1 ) ? x1 - x2 : x2 - x1;
			var fh:int = ( y2 < y1 ) ? y1 - y2 : y2 - y1;
			var fx:int = ( x2 < x1 ) ? x2 : x1;
			var fy:int = ( y2 < y1 ) ? y2 : y1;
			
			rect.x = fx;
			rect.y = fy;
			rect.width = fw;
			rect.height = fh;
			
			return rect;
		}
		
		public function killSelf():void 
		{
			this.parent.removeEventListener(MouseEvent.CLICK, draw);
			if ( !_isFinished && _isDrawing ) 
				this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, draw );
			graphics.clear();
			parent.removeChild(this);
		}
		
		public function get isDrawing():Boolean
		{
			return _isDrawing;
		}
	}
}