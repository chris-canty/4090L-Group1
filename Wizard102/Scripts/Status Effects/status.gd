'''
Status Effects
Element: Corresponding element for the status effect
Proc_ID: Insinuates when the status effect will proc in the character turn
	0: Start of turn
	1: Before Action
	2: Before Hit
rounds: how long it lasts, -1 for if it is infinite until trigger
'''
extends Node

var element: String
var proc_id: int
var rounds: int
var icon: String
