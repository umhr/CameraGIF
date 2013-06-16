package  
{
	
	import com.bit101.components.PushButton;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.utils.Timer;
	import org.bytearray.gif.encoder.GIFEncoder;
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite 
	{
		private var _myGIFEncoder:GIFEncoder = new GIFEncoder();
		private var _tempBitmapList:Vector.<BitmapData> = new Vector.<BitmapData>();
		private var _saveButton:PushButton;
		public function Canvas() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			new PushButton(this, 110, 248, "Capture", onPush);
			_saveButton = new PushButton(this, 110, 300, "Save anime.gif", onSave);
			_saveButton.visible = false;
			
			addChild(CameraManager.getInstance());
		}
		
		private function onPush(e:Event):void 
		{
			_tempBitmapList.length = 0;
			
			var timer:Timer = new Timer(500, 5);
			timer.addEventListener(TimerEvent.TIMER, timer_timer);
			timer.start();
		}
		
		private function timer_timer(e:TimerEvent):void 
		{
			var timer:Timer = e.target as Timer;
			if (timer.currentCount == timer.repeatCount) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timer_timer);
				encode();
			}else {
				setFrame();
			}
		}
		
		private function setFrame():void 
		{
			var bitmapData:BitmapData = CameraManager.getInstance().getBitmapData();
			
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmap.x = 326;
			bitmap.y = _tempBitmapList.length * (bitmap.height * 0.45 + 6);
			bitmap.scaleX = 0.45;
			bitmap.scaleY = 0.45;
			addChild(bitmap);
			
			_tempBitmapList.push(bitmapData);
		}
		
		private function encode():void 
		{
			_myGIFEncoder.start();
			_myGIFEncoder.setRepeat(0);
			
			var n:int = _tempBitmapList.length;
			for (var i:int = 0; i < n; i++) 
			{
				_myGIFEncoder.setDelay(100);
				_myGIFEncoder.addFrame(_tempBitmapList[i]);
			}
			_myGIFEncoder.finish();
			
			_saveButton.visible = true;
		}
		
		private function onSave(e:Event):void 
		{
			var fileReference:FileReference = new FileReference();
			fileReference.save(_myGIFEncoder.stream, "anime.gif");
		}
	}
	
}