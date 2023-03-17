package mc

ModCheckConfidence :: enum
{
	ProbablyNot,
	VeryLikely,
	Definitely,
}

ModCheck :: struct
{
	confidence: ModCheckConfidence,
	desc: string,
}