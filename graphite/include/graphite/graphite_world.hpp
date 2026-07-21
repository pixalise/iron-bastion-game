#ifndef GRAPHITE_WORLD_HPP
#define GRAPHITE_WORLD_HPP

#include <vector>

#include "graphite/graphite_types.hpp"

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>

namespace godot {

class GraphiteWorld : public RefCounted {
	GDCLASS(GraphiteWorld, RefCounted) // NOLINT(*-default-arguments)

protected:
	static void _bind_methods();

public:
	// The world is normally in 3d, graphite is in 2d
	void configure_navigation_grid(int width, int height, double cell_size, float origin_x = 0.0, float origin_z = 0.0);
	void set_navigation_cells(const PackedByteArray &cells);
	void clear_navigation_grid();

	[[nodiscard]] bool is_navigation_grid_configured() const;
	[[nodiscard]] int get_navigation_width() const;
	[[nodiscard]] int get_navigation_height() const;
	[[nodiscard]] double get_navigation_cell_size() const;
	[[nodiscard]] int get_navigation_cell_count() const;
	[[nodiscard]] PackedByteArray get_navigation_cells() const;

private:
	graphite::GridSetup m_navigation_grid_;
	std::vector<graphite::NavCell> m_navigation_cells;
};

} // namespace godot

#endif // GRAPHITE_WORLD_HPP
