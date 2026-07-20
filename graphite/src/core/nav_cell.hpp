#pragma once

#include <cstdint>

namespace graphite {

    using NavCell = std::uint8_t;

    constexpr NavCell TerrainMask = 0x0f;
    constexpr NavCell BlockedMask = 1u << 4;

    enum class TerrainType : std::uint8_t {
        Normal = 0,
        Mud = 1,
        Snow = 2,
        Water = 3,
        Unknown = 15,
    };

    inline TerrainType terrain_type(const NavCell cell) {
        return static_cast<TerrainType>(cell & TerrainMask);
    }

    inline bool is_blocked(const NavCell cell) {
        return (cell & BlockedMask) != 0;
    }

    inline NavCell make_nav_cell(TerrainType terrain, const bool blocked) {
        const auto cell = static_cast<NavCell>(terrain);
        return blocked ? static_cast<NavCell>(cell | BlockedMask) : cell;
    }
}