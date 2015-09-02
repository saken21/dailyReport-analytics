package src.datalist;

import js.JQuery;

class Memberlist {
	
	private static var _jDatalist:JQuery;
	private static inline var TABLE_NAME:String = 'members';
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jDatalist = new JQuery('#memberlist');
		set();
		
	}
	
		/* =======================================================================
		Public - Set
		========================================================================== */
		public static function set(team:String = null):Void {
			
			var where:String = '';
			if (team != null) where = 'team = "' + team + '"';
			
			Datalist.set(_jDatalist,TABLE_NAME,where);

		}

}