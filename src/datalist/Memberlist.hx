package src.datalist;

import js.JQuery;
import src.view.Form;

class Memberlist {
	
	private static var _jOptions:JQuery;
	private static inline var TABLE_NAME:String = 'members';
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		var jParent:JQuery = new JQuery('#memberlist');
		
		jParent.on('setDatalist',function(event:JqEvent):Void {
			_jOptions = jParent.find('option');
		});
		
		Datalist.set(jParent,TABLE_NAME,['id','name','team']);
		
	}
	
		/* =======================================================================
		Public - Select
		========================================================================== */
		public static function select(team:String):Void {
			
			if (team == null) {
				
				_jOptions.prop('disabled',false);
				
			} else {
				
				_jOptions.prop('disabled',true);
				_jOptions.filter('[data-team="' + team + '"]').prop('disabled',false);
				
			}
			
			Form.setInput('member');

		}
		
		/* =======================================================================
		Public - Get ID
		========================================================================== */
		public static function getID(value:String):Int {
			
			return _jOptions.filter('[value="' + value + '"]').data('id');

		}

}