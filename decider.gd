class_name Decider
extends Node

## The Decider, when given a phrase (usually a question), will make a usually
## random determination on how to respond. It runs a rudimentary analysis on
## whether or not the phrase is a yes/no question, and then either randomly chooses
## between yes/no or from the set list of phrases.

## When a decision is made, the Decider fires a signal containing a String with the
## given phrase inside.

signal decided(answer: String, has_trauma: bool)


var generator: RandomNumberGenerator
var yes_no_answers: Array[String] = [
	"YES",
	"NO",
	"MAYBE"
]
var yes_no_weights: Array[float] = [1.0, 1.0, 0.05]

var gen_answers: Array[String] = [
	"Example answer",
	"Other example answer",
	"Whatever man",
	"Im hungy"
]

var profanity_filter: Array[String] = [
	"FUCK", "SHIT", "ASS", "COCK", "WHORE", "CUNT", "BASTARD", "BITCH", "CUM", "DICK", "SLUT",
	"CRAP", "SCUM", "SEMEN", "WANKER", "DAMN" 
]

var profanity_answers: Array[String] = [
	"Naughty words",
	"Unacceptable",
	"Watch language",
	"Offensive",
	"Fix what you got going on"
]


func _ready() -> void:
	generator = RandomNumberGenerator.new()


func process_question(phrase: String) -> void:
	phrase = phrase.to_upper()
	var answer: String = ""
	var should_have_trauma: bool = false
	## Must send a signal containing an answer.
	if _has_profanity(phrase):
		#answer = profanity_answers.pick_random()
		answer = Responses.get_naughty_response()
		should_have_trauma = true
	elif _is_yes_no(phrase):
		answer = yes_no_answers[generator.rand_weighted(yes_no_weights)]
	else:
		#answer = gen_answers.pick_random()
		answer = Responses.get_normal_response()
	decided.emit(answer, should_have_trauma)


func _is_yes_no(phrase: String) -> bool:
	phrase = phrase.strip_edges()
	var words: PackedStringArray = phrase.to_lower().split(" ")
	var yes_no_iterrogatives: Array = ["do", "does", "did", "is", "are", "am", "was",
		"were", "has", "have", "had", "can", "could", "may", "might", "must",
		"shall", "should", "will", "would"]
	if words.size() > 0 and words[0] in yes_no_iterrogatives:
		return true
	return false


func _has_profanity(phrase: String) -> bool:
	for cuss in profanity_filter:
		if cuss in phrase:
			return true
	return false


func _on_ui_submitted(text: String) -> void:
	process_question(text)
