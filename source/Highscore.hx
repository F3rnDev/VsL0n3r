package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songRatings:Map<String, String> = new Map();
	public static var songAccuracy:Map<String, Float> = new Map(); //used to set the rating and the accuracy
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRatings:Map<String, String> = new Map<String, String>();
	public static var songAccuracy:Map<String, Float> = new Map<String, Float>(); //used to set the rating and the accuracy
	#end


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?opp:Bool):Void
	{
		var daSong:String = formatSong(song, diff, opp);
		
		#if !switch
		NGio.postScore(score, song);
		#end

		if(!FlxG.save.data.botplay)
		{
			if (songScores.exists(daSong))
			{
				if (songScores.get(daSong) < score)
					setScore(daSong, score);
			}
			else
				setScore(daSong, score);
		}else trace('BotPlay detected. Score saving is disabled.');
	}

	public static function saveRating(song:String, accuracy:Float = 0, rating:String = "N/A", ?diff:Int = 0, ?opp:Bool):Void
	{
		var daSong:String = formatSong(song, diff, opp);
		var curRating:String = rating.split(')')[0];

		if(!FlxG.save.data.botplay){

			//get ACC
			if (songAccuracy.exists(daSong))
			{
				if (songAccuracy.get(daSong) < accuracy)
				{
					setACC(daSong, accuracy);
				}
			}
			else
				setACC(daSong, accuracy);


			//get Rating
			if (songRatings.exists(daSong))
			{
				if (generateRatingID(songRatings.get(daSong)) < generateRatingID(curRating))
				{
					setRating(daSong, curRating);
				}
			}
			else
				setRating(daSong, curRating);

		}else trace('BotPlay detected. Rating saving is disabled.');
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0, opp:Bool):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end

		if(!FlxG.save.data.botplay)
		{
			var daWeek:String = formatSong('week' + week, diff, opp);

			if (songScores.exists(daWeek))
			{
				if (songScores.get(daWeek) < score)
					setScore(daWeek, score);
			}
			else
				setScore(daWeek, score);
		}else trace('BotPlay detected. Score saving is disabled.');
	}

	//i'm dumb, thanks kade
	static function generateRatingID(rating:String):Int
	{ 
		var ratingID:Int = 0;

		switch (rating){
			case "Clear":
				ratingID = 0;
			
			case "SDCB":
				ratingID = 1;
					
			case "FC":
				ratingID = 2;
						
			case "GFC":
				ratingID = 3;
			
			case "MFC":
				ratingID = 4;
		}

		return ratingID;
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:String):Void 
	{
		songRatings.set(song, rating);
		FlxG.save.data.songRatings = songRatings;	
		FlxG.save.flush();
	}

	static function setACC(song:String, accuracy:Float):Void
	{
		songAccuracy.set(song, accuracy);
		FlxG.save.data.songAccuracy = songAccuracy;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int, opp:Bool):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		if (opp)
			daSong += '-opponent';
		else
			daSong += '-player';

		return daSong;
	}

	public static function getScore(song:String, diff:Int, opp:Bool):Int
	{
		if (!songScores.exists(formatSong(song, diff, opp)))
			setScore(formatSong(song, diff, opp), 0);

		return songScores.get(formatSong(song, diff, opp));
	}

	public static function getRating(song:String, diff:Int, opp:Bool):String
	{
		var daSong:String = formatSong(song, diff, opp);

		if(!songRatings.exists(daSong)){
			setRating(daSong, "N/A");
		}

		if(!songAccuracy.exists(daSong)){
			setACC(daSong, 0);
		}

		return songRatings.get(daSong) + "(" + songAccuracy.get(daSong) + "%)";
	}

	public static function getWeekScore(week:Int, diff:Int, opp:Bool):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff, opp)))
			setScore(formatSong('week' + week, diff, opp), 0);

		return songScores.get(formatSong('week' + week, diff, opp));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
			songAccuracy = FlxG.save.data.songAccuracy;
			songRatings = FlxG.save.data.songRatings;
		}
	}
}