#ifndef GRAPHITE_TYPES_HPP
#define GRAPHITE_TYPES_HPP

#define NAV_CELL_TERRAIN_MASK 0x0fu
#define NAV_CELL_BLOCKED_MASK (1u << 4)

#include <cstdint>
#include <limits>

namespace graphite {

using UnitId = std::uint32_t;
using SquadId = std::uint32_t;
using HordeId = std::uint32_t;
using TeamId = std::uint16_t;
using NavCell = std::uint8_t;

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

inline TerrainType terrain_type(const NavCell cell) {
	return static_cast<TerrainType>(cell & NAV_CELL_TERRAIN_MASK);
}

inline bool is_blocked(const NavCell cell) {
	return (cell & NAV_CELL_BLOCKED_MASK) != 0;
}

inline NavCell make_nav_cell(TerrainType terrain, const bool blocked) {
	NavCell cell = 0;
	// Masking via NavCellTerrainMask guarantees only the lower 4 bits
	cell |= static_cast<NavCell>(terrain) & NAV_CELL_TERRAIN_MASK;
	if (blocked) {
		return cell | NAV_CELL_BLOCKED_MASK;
	}
	return cell;
}

struct GridSetup {
	std::uint32_t width = 0;
	std::uint32_t height = 0;
	float cell_size = 1.0f;
	float origin_x = 0.0f;
	float origin_z = 0.0f;

	[[nodiscard]] std::uint32_t cell_count() const {
		return width * height;
	}
};

} // namespace graphite

#endif // GRAPHITE_TYPES_HPP
