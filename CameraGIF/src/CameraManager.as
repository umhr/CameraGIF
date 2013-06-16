package  
{
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.text.TextField;
	/**
	 * ...
	 * @author umhr
	 */
	public class CameraManager extends Sprite 
	{
		private static var _instance:CameraManager;
		private var _camera:Camera;
		private var _video:Video;
		public function CameraManager(block:Block){init();};
		public static function getInstance():CameraManager{
			if ( _instance == null ) {_instance = new CameraManager(new Block());};
			return _instance;
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
			
			_camera = Camera.getCamera();
			//カメラの存在を確認
			if (_camera) {
				_camera.setMode(320, 240, 15);
				_video = new Video(320, 240);
				_video.attachCamera(_camera);
				addChild(_video);
			} else {
				var textField:TextField = new TextField();
				textField.text = "カメラが見つかりません。カメラを有効にしてリロードしてください。"
				textField.textColor = 0xFF0000;
				textField.width = 400;
				addChild(textField);
			}
		}
		
		public function getBitmapData():BitmapData {
			if(_camera){
				var result:BitmapData = new BitmapData(_camera.width, _camera.height);
				result.draw(_video);
				return result;
			}else {
				return new BitmapData(320, 240, false, 0xFFFFFFFF * Math.random());
			}
		}
		
		
	}
	
}
class Block { };
