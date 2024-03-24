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


func change(index, value):
	data[index] = data[index] + value

func create(array : Array) -> Datapack:
	data = array
	return self

func append(element) -> void:
	data.append(element)

#pop front
func pop():
	return data.pop_front()



func out() -> void:
	print(data)
