class_name Datapack
extends Node

#an array wrapper intended for serializing data into easier to edit values

#only add INTS and VECTORS

var data := []

func length() -> int:
	return len(data)

func clone(otherPack : Datapack) -> Datapack:
	data = []
	for i in otherPack.data:
		data.append(i)
	return self

func retrieve(index):
	return data[index]

func put(index, value):
	data[index] = value

func create(array : Array) -> Datapack:
	data = array
	return self

func append(element) -> void:
	data.append(element)

#pop front
func pop():
	return data.pop_front()

#ints to vectors
func write() -> void: #write mode
	var temp := []
	while len(data) != 0:
		temp.append(Vector2(data.pop_front(),data.pop_front()))
	data = temp

#BY DEFAULT IN WRITE MODE

#vectors to ints
func read() -> void: #read mode
	var temp := []
	while len(data) != 0:
		var vector = data.pop_front()
		temp.append(vector.x)
		temp.append(vector.y)
	data = temp

func out() -> void:
	print(data)
