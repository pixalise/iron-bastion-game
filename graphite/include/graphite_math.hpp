#ifndef GRAPHITE_MATH_HPP
#define GRAPHITE_MATH_HPP

#include <godot_cpp/classes/ref_counted.hpp>

namespace godot {

class GraphiteMath : public RefCounted {
	GDCLASS(GraphiteMath, RefCounted)

protected:
	static void _bind_methods();

public:
	double add_numbers(double a, double b) const;
};

} // namespace godot

#endif // GRAPHITE_MATH_HPP
