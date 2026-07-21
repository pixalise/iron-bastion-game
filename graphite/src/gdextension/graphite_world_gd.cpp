#include "graphite/graphite_world.hpp"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/error_macros.hpp>

namespace godot {

void GraphiteWorld::_bind_methods() {
	ClassDB::bind_method(
		D_METHOD("configure_navigation_grid", "width", "height", "cell_size"),
		&GraphiteWorld::configure_navigation_grid
	);
	ClassDB::bind_method(
		D_METHOD("set_navigation_cells", "cells"),
		&GraphiteWorld::set_navigation_cells
	);
	ClassDB::bind_method(
		D_METHOD("clear_navigation_grid"),
		&GraphiteWorld::clear_navigation_grid
	);
	ClassDB::bind_method(
		D_METHOD("is_navigation_grid_configured"),
		&GraphiteWorld::is_navigation_grid_configured
	);
	ClassDB::bind_method(
		D_METHOD("get_navigation_width"),
		&GraphiteWorld::get_navigation_width
	);
	ClassDB::bind_method(
		D_METHOD("get_navigation_height"),
		&GraphiteWorld::get_navigation_height
	);
	ClassDB::bind_method(
		D_METHOD("get_navigation_cell_size"),
		&GraphiteWorld::get_navigation_cell_size
	);
	ClassDB::bind_method(
		D_METHOD("get_navigation_cell_count"),
		&GraphiteWorld::get_navigation_cell_count
	);
	ClassDB::bind_method(
		D_METHOD("get_navigation_cells"),
		&GraphiteWorld::get_navigation_cells
	);
}

void GraphiteWorld::configure_navigation_grid(int width, int height, double cell_size, float origin_x, float origin_z) {
	ERR_FAIL_COND_MSG(width <= 0, "Graphite navigation grid width must be greater than zero.");
	ERR_FAIL_COND_MSG(height <= 0, "Graphite navigation grid height must be greater than zero.");
	ERR_FAIL_COND_MSG(cell_size <= 0.0, "Graphite navigation grid cell size must be greater than zero.");

	navigation_grid_.width = static_cast<std::uint32_t>(width);
	navigation_grid_.height = static_cast<std::uint32_t>(height);
	navigation_grid_.cell_size = static_cast<float>(cell_size);
	navigation_grid_.origin_x = origin_x;
	navigation_grid_.origin_z = origin_z;
	navigation_cells_.clear();
}

void GraphiteWorld::set_navigation_cells(const PackedByteArray &cells) {
	ERR_FAIL_COND_MSG(
		!is_navigation_grid_configured(),
		"Configure the Graphite navigation grid before setting cells."
	);
	ERR_FAIL_COND_MSG(
		cells.size() != get_navigation_cell_count(),
		"Graphite navigation cell data must contain exactly width * height cells."
	);

	navigation_cells_ = cells;
}

void GraphiteWorld::clear_navigation_grid() {
	navigation_grid_ = graphite::GridSetup {};
	navigation_cells_.clear();
}

bool GraphiteWorld::is_navigation_grid_configured() const {
	return navigation_grid_.width > 0 && navigation_grid_.height > 0 && navigation_grid_.cell_size > 0.0f;
}

int GraphiteWorld::get_navigation_width() const {
	return static_cast<int>(navigation_grid_.width);
}

int GraphiteWorld::get_navigation_height() const {
	return static_cast<int>(navigation_grid_.height);
}

double GraphiteWorld::get_navigation_cell_size() const {
	return static_cast<double>(navigation_grid_.cell_size);
}

int GraphiteWorld::get_navigation_cell_count() const {
	return static_cast<int>(navigation_grid_.cell_count());
}

PackedByteArray GraphiteWorld::get_navigation_cells() const {
	return navigation_cells_;
}

} // namespace godot
