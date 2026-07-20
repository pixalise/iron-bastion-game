#include "graphite_math.hpp"

#include <godot_cpp/core/class_db.hpp>

namespace godot {

void GraphiteMath::_bind_methods() {
	ClassDB::bind_method(D_METHOD("add_numbers", "a", "b"), &GraphiteMath::add_numbers);
}

double GraphiteMath::add_numbers(double a, double b) const {
	return a + b;
}

} // namespace godot
