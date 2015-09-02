package src.datalist;

import js.JQuery;

class Worklist {
	
	private static var _jDatalist:JQuery;
	private static inline var TABLE_NAME:String = 'works';
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jDatalist = new JQuery('#worklist');
		set();
		
	}
	
		/* =======================================================================
		Public - Set
		========================================================================== */
		public static function set(clientID:Int = null):Void {
			
			var where:String = '';
			if (clientID != null) where = 'client_id = ' + clientID;
			
			Datalist.set(_jDatalist,TABLE_NAME,where);

		}

}