#ifndef GRAPHITE_WORLD_HPP
#define GRAPHITE_WORLD_HPP

#include "graphite/graphite_types.hpp"

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>

namespace godot {

class GraphiteWorld : public RefCounted {
	GDCLASS(GraphiteWorld, RefCounted)

protected:
	static void _bind_methods();

public:
	// The world is normally in 3d, graphite is in 2d
	void configure_navigation_grid(int width, int height, double cell_size, float origin_x = 0.0, float origin_z = 0.0);
	void set_navigation_cells(const PackedByteArray &cells);
	void clear_navigation_grid();

	bool is_navigation_grid_configured() const;
	int get_navigation_width() const;
	int get_navigation_height() const;
	double get_navigation_cell_size() const;
	int get_navigation_cell_count() const;
	PackedByteArray get_navigation_cells() const;

private:
	graphite::GridSetup navigation_grid_;
	PackedByteArray navigation_cells_;
};

} // namespace godot

#endif // GRAPHITE_WORLD_HPP
