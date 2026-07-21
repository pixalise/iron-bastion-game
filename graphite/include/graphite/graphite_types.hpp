#ifndef GRAPHITE_TYPES_HPP
#define GRAPHITE_TYPES_HPP

#define SIMULATION_CELL_TERRAIN_MASK 0x0fu
#define SIMULATION_CELL_BLOCKED_MASK (1u << 4)

#include <cassert>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <vector>

namespace graphite {

using UnitId = std::uint32_t;
using SquadId = std::uint32_t;
using HordeId = std::uint32_t;
using TeamId = std::uint16_t;
using SimulationCell = std::uint8_t;

constexpr UnitId InvalidUnitId = std::numeric_limits<UnitId>::max();
constexpr SquadId InvalidSquadId = std::numeric_limits<SquadId>::max();
constexpr HordeId InvalidHordeId = std::numeric_limits<HordeId>::max();
constexpr TeamId InvalidTeamId = std::numeric_limits<TeamId>::max();

enum class TerrainType : std::uint8_t {
	Normal = 0,
	Mud = 1,
	Snow = 2,
	Water = 3,
	Unknown = 15,
};

inline TerrainType terrain_type(const SimulationCell cell) {
	return static_cast<TerrainType>(cell & SIMULATION_CELL_TERRAIN_MASK);
}

inline bool is_blocked(const SimulationCell cell) {
	return (cell & SIMULATION_CELL_BLOCKED_MASK) != 0;
}

inline SimulationCell make_simulation_cell(TerrainType terrain, const bool blocked) {
	SimulationCell cell = 0;
	// Masking via SIMULATION_CELL_TERRAIN_MASK guarantees only the lower 4 bits.
	cell |= static_cast<SimulationCell>(terrain) & SIMULATION_CELL_TERRAIN_MASK;
	if (blocked) {
		return cell | SIMULATION_CELL_BLOCKED_MASK;
	}
	return cell;
}

struct GridCell {
	std::int32_t x = 0;
	std::int32_t z = 0;
};

struct WorldPosition2 {
	float x = 0.0f;
	float z = 0.0f;
};

struct SimulationGrid {
	std::uint32_t width = 0;
	std::uint32_t height = 0;
	float cell_size = 1.0f;
	float origin_x = 0.0f;
	float origin_z = 0.0f;
	std::vector<SimulationCell> cells;

	[[nodiscard]] std::uint32_t cell_count() const { return width * height; }
	[[nodiscard]] bool is_configured() const { return width > 0 && height > 0 && cell_size > 0.0f; }
	[[nodiscard]] bool has_cells() const {
		return is_configured() && cells.size() == static_cast<std::size_t>(cell_count());
	}

	[[nodiscard]] bool contains_cell(const std::uint32_t x, const std::uint32_t z) const {
		return x < width && z < height;
	}

	[[nodiscard]] bool contains_cell(const GridCell cell) const {
		return cell.x >= 0 && cell.z >= 0 &&
		       contains_cell(static_cast<std::uint32_t>(cell.x),
		                     static_cast<std::uint32_t>(cell.z));
	}

	[[nodiscard]] std::uint32_t cell_index(const std::uint32_t x, const std::uint32_t z) const {
		assert(is_configured() &&
		       "SimulationGrid must be configured before calculating cell indices.");
		assert(contains_cell(x, z) && "SimulationGrid cell index is out of bounds.");
		return z * width + x;
	}

	[[nodiscard]] std::uint32_t cell_index(const GridCell cell) const {
		assert(contains_cell(cell) && "SimulationGrid cell index is out of bounds.");
		return cell_index(static_cast<std::uint32_t>(cell.x), static_cast<std::uint32_t>(cell.z));
	}

	[[nodiscard]] GridCell world_to_cell(const float world_x, const float world_z) const {
		assert(is_configured() &&
		       "SimulationGrid must be configured before converting world positions.");

		return {
		    static_cast<std::int32_t>(std::floor((world_x - origin_x) / cell_size)),
		    static_cast<std::int32_t>(std::floor((world_z - origin_z) / cell_size)),
		};
	}

	[[nodiscard]] WorldPosition2 cell_to_world_center(const std::uint32_t x,
	                                                  const std::uint32_t z) const {
		assert(is_configured() &&
		       "SimulationGrid must be configured before converting cell positions.");
		assert(contains_cell(x, z) && "SimulationGrid cell position is out of bounds.");

		// A cell's integer coordinate marks its lower world-space edge; adding half a cell
		// returns the center point Godot should use for unit placement or debug markers.
		return {
		    origin_x + (static_cast<float>(x) + 0.5f) * cell_size,
		    origin_z + (static_cast<float>(z) + 0.5f) * cell_size,
		};
	}

	[[nodiscard]] WorldPosition2 cell_to_world_center(const GridCell cell) const {
		assert(contains_cell(cell) && "SimulationGrid cell position is out of bounds.");
		return cell_to_world_center(static_cast<std::uint32_t>(cell.x),
		                            static_cast<std::uint32_t>(cell.z));
	}
};

} // namespace graphite

#endif // GRAPHITE_TYPES_HPP
