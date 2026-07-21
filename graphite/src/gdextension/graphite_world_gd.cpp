#include "graphite/graphite_world.hpp"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/error_macros.hpp>

namespace godot {

void GraphiteWorld::_bind_methods() {
	ClassDB::bind_method(D_METHOD("configure_simulation_grid", "width", "height", "cell_size",
	                              "origin_x", "origin_z"),
	                     &GraphiteWorld::configure_simulation_grid, DEFVAL(0.0f), DEFVAL(0.0f));
	ClassDB::bind_method(D_METHOD("set_simulation_cells", "cells"),
	                     &GraphiteWorld::set_simulation_cells);
	ClassDB::bind_method(D_METHOD("clear_simulation_grid"), &GraphiteWorld::clear_simulation_grid);
	ClassDB::bind_method(D_METHOD("is_simulation_grid_configured"),
	                     &GraphiteWorld::is_simulation_grid_configured);
	ClassDB::bind_method(D_METHOD("get_simulation_grid_width"),
	                     &GraphiteWorld::get_simulation_grid_width);
	ClassDB::bind_method(D_METHOD("get_simulation_grid_height"),
	                     &GraphiteWorld::get_simulation_grid_height);
	ClassDB::bind_method(D_METHOD("get_simulation_grid_cell_size"),
	                     &GraphiteWorld::get_simulation_grid_cell_size);
	ClassDB::bind_method(D_METHOD("get_simulation_cell_count"),
	                     &GraphiteWorld::get_simulation_cell_count);
	ClassDB::bind_method(D_METHOD("get_simulation_cells"), &GraphiteWorld::get_simulation_cells);
}

void GraphiteWorld::configure_simulation_grid(int width, int height, double cell_size,
                                              float origin_x, float origin_z) {
	ERR_FAIL_COND_MSG(width <= 0, "Graphite simulation grid width must be greater than zero.");
	ERR_FAIL_COND_MSG(height <= 0, "Graphite simulation grid height must be greater than zero.");
	ERR_FAIL_COND_MSG(cell_size <= 0.0,
	                  "Graphite simulation grid cell size must be greater than zero.");

	m_simulation_grid.width = static_cast<std::uint32_t>(width);
	m_simulation_grid.height = static_cast<std::uint32_t>(height);
	m_simulation_grid.cell_size = static_cast<float>(cell_size);
	m_simulation_grid.origin_x = origin_x;
	m_simulation_grid.origin_z = origin_z;
	m_simulation_grid.cells.clear();
}

void GraphiteWorld::set_simulation_cells(const PackedByteArray& cells) {
	ERR_FAIL_COND_MSG(!is_simulation_grid_configured(),
	                  "Configure the Graphite simulation grid before setting cells.");
	ERR_FAIL_COND_MSG(cells.size() != get_simulation_cell_count(),
	                  "Graphite simulation cell data must contain exactly width * height cells.");

	m_simulation_grid.cells.clear();
	m_simulation_grid.cells.reserve(static_cast<std::size_t>(cells.size()));

	for (int64_t index = 0; index < cells.size(); ++index) {
		const auto cell = static_cast<graphite::SimulationCell>(cells[index]);

		ERR_FAIL_COND_MSG(graphite::terrain_type(cell) == graphite::TerrainType::Unknown,
		                  "Graphite simulation cell data contains an Unknown terrain cell.");

		m_simulation_grid.cells.push_back(cell);
	}
}

void GraphiteWorld::clear_simulation_grid() {
	m_simulation_grid = graphite::SimulationGrid{};
	m_simulation_grid.cells.clear();
}

bool GraphiteWorld::is_simulation_grid_configured() const {
	return m_simulation_grid.is_configured();
}

int GraphiteWorld::get_simulation_grid_width() const {
	return static_cast<int>(m_simulation_grid.width);
}

int GraphiteWorld::get_simulation_grid_height() const {
	return static_cast<int>(m_simulation_grid.height);
}

double GraphiteWorld::get_simulation_grid_cell_size() const {
	return m_simulation_grid.cell_size;
}

int GraphiteWorld::get_simulation_cell_count() const {
	return static_cast<int>(m_simulation_grid.cell_count());
}

PackedByteArray GraphiteWorld::get_simulation_cells() const {
	PackedByteArray cells;
	cells.resize(static_cast<int64_t>(m_simulation_grid.cells.size()));

	for (int64_t index = 0; index < cells.size(); ++index) {
		cells[index] = m_simulation_grid.cells[static_cast<std::size_t>(index)];
	}

	return cells;
}

} // namespace godot
