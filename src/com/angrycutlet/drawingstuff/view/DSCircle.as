package com.angrycutlet.drawingstuff.view
{
	import com.angrycutlet.drawingstuff.DSToolEvents;
	import com.angrycutlet.drawingstuff.interfaces.IDSDrawable;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.core.SpriteVisualElement;
	
	public class DSCircle extends SpriteVisualElement implements IDSDrawable
	{
		private var _isDrawing:Boolean = false;
		private var _isFinished:Boolean = false;
		private var isSelected:Boolean = false;
		private var points:Vector.<Point>;
		
		private var origin:Point;
		private var clickCount:int = 0;
		
		private var fillColor:uint;
		private var strokeColor:uint;
		private var opacity:Number;
		
		public function DSCircle( fillColor:uint=0x0, strokeColor:uint=0x0, opacity:Number=1 )
		{
			super();
			this.fillColor = fillColor;
			this.strokeColor = strokeColor;
			this.opacity = opacity;
			
			this.addEventListener(Event.ADDED, initTool );
		}
		
		protected function initTool(event:Event):void
		{
			this.parent.addEventListener(MouseEvent.CLICK, draw );
		}
		
		private function draw(e:MouseEvent):void 
		{
			if ( e.type == MouseEvent.CLICK ) clickCount++;
			if (!_isDrawing)
			{
				points = new Vector.<Point>;
				origin = new Point(e.localX, e.localY);
				points.push( origin );
				this.parent.addEventListener(MouseEvent.MOUSE_MOVE, draw );
				_isDrawing = true;
			}
			points[1] = new Point(e.localX, e.localY);
			
			this.graphics.clear();
			this.graphics.moveTo( origin.x, origin.y );
			this.graphics.beginFill( fillColor, opacity );
			this.graphics.lineStyle( 1, strokeColor, opacity );
			this.graphics.drawCircle( origin.x, origin.y, radius );
			this.graphics.endFill();
			
			if ( _isDrawing && e.type == MouseEvent.CLICK && clickCount == 2 )
			{
				this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, draw );
				this.parent.removeEventListener(MouseEvent.CLICK, draw );
				_isFinished = true;
				sendEvent( DSToolEvents.FINISHED_DRAWING );
			}
		}
		
		private function get radius():Number
		{
			var r:Number;
			var x1:Number = points[0].x;
			var x2:Number = points[1].x;
			var y1:Number = points[0].y;
			var y2:Number = points[1].y;
			var dx:Number = ( x1 > x2 ) ? x1-x2 : x2-x1;
			var dy:Number = ( y1 > y2 ) ? y1-y2 : y2-y1;
			r = Math.sqrt( dx*dx + dy*dy );
			return r;
		}
		
		private function sendEvent(event:String):void 
		{
			this.dispatchEvent( new Event( event, true ));
		}
		
		public function get isDrawing():Boolean
		{
			return _isDrawing;
		}
		
		public function killSelf():void
		{
			this.parent.removeEventListener(MouseEvent.CLICK, draw );
			if ( !_isFinished && _isDrawing )
				this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, draw );
			graphics.clear();
			parent.removeChild(this);
				
		}
	}
}