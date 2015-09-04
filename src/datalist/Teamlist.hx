package src.datalist;

import js.JQuery;

class Teamlist {
	
	private static var _jOptions:JQuery;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		var jParent:JQuery = new JQuery('#teamlist');
		_jOptions = jParent.find('option');
		
	}
		
		/* =======================================================================
		Public - Get Team
		========================================================================== */
		public static function getTeam(value:String):String {
			
			return _jOptions.filter('[value="' + value + '"]').data('team');

		}

}