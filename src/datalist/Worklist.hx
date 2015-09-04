package src.datalist;

import js.JQuery;
import src.view.Form;

class Worklist {
	
	private static var _jOptions:JQuery;
	private static inline var TABLE_NAME:String = 'works';
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		var jParent:JQuery = new JQuery('#worklist');
		
		jParent.on('setDatalist',function(event:JqEvent):Void {
			_jOptions = jParent.find('option');
		});
		
		Datalist.set(jParent,TABLE_NAME,['id','name','client_id']);
		
		
	}
	
		/* =======================================================================
		Public - Select
		========================================================================== */
		public static function select(clientID:Int):Void {
			
			if (clientID == null) {
				
				_jOptions.prop('disabled',false);
				
			} else {
				
				_jOptions.prop('disabled',true);
				_jOptions.filter('[data-clientid="' + clientID + '"]').prop('disabled',false);
				
			}
			
			Form.setInput('work');

		}
		
		/* =======================================================================
		Public - Get ID
		========================================================================== */
		public static function getID(value:String):Int {
			
			return _jOptions.filter('[value="' + value + '"]').data('id');

		}

}