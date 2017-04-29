package src.datalist;

import js.JQuery;
import src.db.Works;
import src.view.Form;

class Worklist {
	
	private static var _jOptions:JQuery;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		var jParent:JQuery = new JQuery('#worklist').html(Datalist.getHTML(Works.getDB()));
		_jOptions = jParent.find('option');
		
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
			
			return _jOptions.not('disabled').filter('[value="' + value + '"]').data('id');
			
		}

}