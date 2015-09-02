package src.datalist;

import js.JQuery;

class Clientlist {
	
	private static var _jDatalist:JQuery;
	private static inline var TABLE_NAME:String = 'clients';
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jDatalist = new JQuery('#clientlist');
		set();
		
	}
	
		/* =======================================================================
		Public - Set
		========================================================================== */
		public static function set():Void {
			
			Datalist.set(_jDatalist,TABLE_NAME);

		}

}