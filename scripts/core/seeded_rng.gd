class_name SeededRng
extends RefCounted
## Deterministic random source. Class plans and question draws are seeded with
## hash(date + period) so saving and reloading never changes what happens (seção 46.6).
var rng := RandomNumberGenerator.new()

static func from_string(key: String) -> SeededRng:
	var source := SeededRng.new()
	source.rng.seed = hash(key)
	return source

func chance(probability: float) -> bool:
	return rng.randf() < probability

func range_int(low: int, high: int) -> int:
	return rng.randi_range(low, high)

func pick(items: Array) -> Variant:
	if items.is_empty():
		return null
	return items[rng.randi_range(0, items.size() - 1)]

## Returns the index of the chosen weight, or -1 when every weight is zero.
func weighted(weights: Array) -> int:
	var total := 0.0
	for weight in weights:
		total += maxf(0.0, float(weight))
	if total <= 0.0:
		return -1
	var roll := rng.randf() * total
	for i in range(weights.size()):
		roll -= maxf(0.0, float(weights[i]))
		if roll < 0.0:
			return i
	return weights.size() - 1

func shuffled(items: Array) -> Array:
	var copy := items.duplicate()
	for i in range(copy.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var swap: Variant = copy[i]
		copy[i] = copy[j]
		copy[j] = swap
	return copy
