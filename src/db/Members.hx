package src.db;
 
class Members {
	
	private static var _database:Database;
	
	private static inline var TABLE_NAME:String = 'members';
	private static var COLUMN_LIST:Array<String> = ['id','parmanent_id','name','section','team','is_visible'];
	
	/* =======================================================================
	Public - Load
	========================================================================== */
	public static function load():Void {
		
		_database = new Database(TABLE_NAME,COLUMN_LIST);
		
	}
	
		/* =======================================================================
		Public - Get DB
		========================================================================== */
		public static function getDB():Array<Dynamic> {
			
			return _database.getDB();

		}

}