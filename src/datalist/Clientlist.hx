package src.datalist;

import js.JQuery;

class Clientlist {
	
	private static var _datalist:Datalist;
	private static var _jOptions:JQuery;
	
	private static inline var TABLE_NAME:String = 'clients';
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		var jParent:JQuery = new JQuery('#clientlist');
		
		jParent.on('setDatalist',function(event:JqEvent):Void {
			_jOptions = jParent.find('option');
		});
		
		_datalist = new Datalist(jParent,TABLE_NAME,['id','name']);
		
	}
		
		/* =======================================================================
		Public - Get ID
		========================================================================== */
		public static function getID(value:String):Int {
			
			return _jOptions.filter('[value="' + value + '"]').data('id');

		}
		
		/* =======================================================================
		Public - Get DB
		========================================================================== */
		public static function getDB():Array<Dynamic> {
			
			return _datalist.getDB();

		}

}