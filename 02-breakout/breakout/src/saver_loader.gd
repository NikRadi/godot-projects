extends Node
class_name SaverLoader


const SAVE_FILE_PATH := "res://savegame.data"


static func save_high_score(high_score: int) -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(high_score)
	file.close()


static func load_high_score() -> int:
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		save_high_score(0)
		return 0
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var high_score : int = file.get_var()
	file.close()
	return high_score
