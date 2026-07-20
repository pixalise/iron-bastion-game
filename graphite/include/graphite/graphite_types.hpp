#ifndef GRAPHITE_TYPES_HPP
#define GRAPHITE_TYPES_HPP

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

constexpr NavCell NavCellTerrainMask = 0x0f;
constexpr NavCell NavCellBlockedMask = 1u << 4;

enum class TerrainType : std::uint8_t {
	Normal = 0,
	Mud = 1,
	Snow = 2,
	Water = 3,
	Unknown = 15,
};

struct GridSetup {
	std::uint32_t width = 0;
	std::uint32_t height = 0;
	float cell_size = 1.0f;

	std::uint32_t cell_count() const {
		return width * height;
	}
};

} // namespace graphite

#endif // GRAPHITE_TYPES_HPP
