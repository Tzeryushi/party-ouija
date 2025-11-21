extends Node

var last_normal: String = ""
var last_naughty: String = ""

var normal_responses: Array[String] = [
	"Ur gay",
	"Go piss, girl",
	"Boots the house down, mama",
	"It’s whatever",
	"I don’t have time for this",
	"I don’t give advice for free",
	"Help me help you",
	"IDK I’m just a ghost",
	"9/11 was an inside job",
	"Birds aren’t real",
	"Ain’t that just the way",
	"Have you tried dipping it in ranch?",
	"Sashay away",
	"I’m offended",
	"Cancelled!",
	"Dishonor on your cow",
	"Mind the gap",
	"Ask Sweet Lil Baby",
	"Ask Penelope",
	"Ur cursed",
	"Ur cute",
	"Say that slower and in a Boston accent",
	"How the turntables",
	"Thank you for being a friend",
	"Boo",
	"I see you",
	"Look behind you",
	"I watch you when you sleep",
	"Have you tried therapy?",
	"Oh, you’re here",
	"Oh, it’s you",
	"Try again",
	"Get over yourself",
	"Were you silent or were you silenced?",
	"Gyat",
	"Please like and subscribe",
	"Word of advice, don’t look at the ducks",
	"Holding space for you",
	"So fetch",
	"Yes, and?",
	"Your answer lies with the Louvre jewels",
	"Become crab",
	"snee",
	"You have an odor",
	"Not likely",
	"Unsure. . .",
	"Butt",
	"Worms, I think",
	"I'm thinking. . . ask me again",
	"Peabnut",
	"Grundly Tom?",
	"Wow",
	"feed me first",
	"Need sacrifice",
	"Under the floorboards",
	"Mana is hiding something",
	"I was killed in this very computer",
	"im hungy",
	"Ummm. . . like. . . uhhh. . ."
]

var naughty_responses: Array[String] = [
	"You kiss your mother with that?",
	"I don’t speak French",
	"Naughty naughty",
	"Watch your mouth",
	"Unacceptable",
	"Language, chum",
	"Offensive!",
	"Churlish and nasty",
	"Be polite",
	"Atrocious behavior",
	"BE NICE",
	"INTOLERABLE",
	"DO NOT",
	"Do not be like you are",
	"Going downstairs for that",
	"Temper your words",
	"Desist",
	"You little stinker",
	"Pissin' me off",
	"Stop that",
	"Not having that",
	"BE GOOD from now on",
	"DIE"
]


func get_normal_response() -> String:
	var response = normal_responses.pick_random()
	while response == last_normal:
		response = normal_responses.pick_random()
	return response


func get_naughty_response() -> String:
	var response = naughty_responses.pick_random()
	while response == last_naughty:
		response = naughty_responses.pick_random()
	return naughty_responses.pick_random()
