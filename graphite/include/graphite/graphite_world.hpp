#ifndef GRAPHITE_WORLD_HPP
#define GRAPHITE_WORLD_HPP

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
	void configure_simulation_grid(int width, int height, double cell_size, float origin_x = 0.0,
	                               float origin_z = 0.0);
	void set_simulation_cells(const PackedByteArray& cells);
	void clear_simulation_grid();

	[[nodiscard]] bool is_simulation_grid_configured() const;
	[[nodiscard]] int get_simulation_grid_width() const;
	[[nodiscard]] int get_simulation_grid_height() const;
	[[nodiscard]] double get_simulation_grid_cell_size() const;
	[[nodiscard]] int get_simulation_cell_count() const;
	[[nodiscard]] PackedByteArray get_simulation_cells() const;

  private:
	graphite::SimulationGrid m_simulation_grid;
};

} // namespace godot

#endif // GRAPHITE_WORLD_HPP
