import Scanf

struct Blueprint
    id::Int
    ore::Tuple{Int, Int, Int, Int}
    clay::Tuple{Int, Int, Int, Int}
    obsidian::Tuple{Int, Int, Int, Int}
    geode::Tuple{Int, Int, Int, Int}
    max_ore::Int
end

function parse_line(line)
    (id, ore_ore, clay_ore, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian) = (@Scanf.scanf line "Blueprint %i: Each ore robot costs %i ore. Each clay robot costs %i ore. Each obsidian robot costs %i ore and %i clay. Each geode robot costs %i ore and %i obsidian." Int Int Int Int Int Int Int)[2:end]
    Blueprint(
        id,
        (ore_ore, 0, 0, 0),
        (clay_ore, 0, 0, 0),
        (obsidian_ore, obsidian_clay, 0, 0),
        (geode_ore, 0, geode_obsidian, 0),
        max(ore_ore, clay_ore, obsidian_ore, geode_ore),
    )
end

function run_blueprint(blueprint::Blueprint, ticks_left::Int, money::Tuple{Int, Int, Int, Int}, state::Tuple{Int, Int, Int, Int})
    if ticks_left == 0
        return money[4]
    end

    result = 0

    if state[3] != 0
        ticks = max(cld(blueprint.geode[1] - money[1], state[1]), cld(blueprint.geode[3] - money[3], state[3]))
        ticks = max(ticks + 1, 1)
        if ticks ≤ ticks_left
            result = max(result, run_blueprint(blueprint, ticks_left - ticks, money .+ (state .* ticks) .- blueprint.geode, state .+ (0, 0, 0, 1)))
        end
    end

    if state[1] < blueprint.max_ore
        ticks = cld(blueprint.ore[1] - money[1], state[1])
        ticks = max(ticks + 1, 1)
        if ticks ≤ ticks_left
            result = max(result, run_blueprint(blueprint, ticks_left - ticks, money .+ (state .* ticks) .- blueprint.ore, state .+ (1, 0, 0, 0)))
        end
    end

    if state[2] < blueprint.obsidian[2]
        ticks = cld(blueprint.clay[1] - money[1], state[1])
        ticks = max(ticks + 1, 1)
        if ticks ≤ ticks_left
            result = max(result, run_blueprint(blueprint, ticks_left - ticks, money .+ (state .* ticks) .- blueprint.clay, state .+ (0, 1, 0, 0)))
        end
    end

    if state[3] < blueprint.geode[3]
        if state[2] != 0
            ticks = max(cld(blueprint.obsidian[1] - money[1], state[1]), cld(blueprint.obsidian[2] - money[2], state[2]))
            ticks = max(ticks + 1, 1)
            if ticks ≤ ticks_left
                result = max(result, run_blueprint(blueprint, ticks_left - ticks, money .+ (state .* ticks) .- blueprint.obsidian, state .+ (0, 0, 1, 0)))
            end
        end
    end

    if result == 0
        return (money .+ (state .* ticks_left))[4]
    end

    return result
end

part1(infile) = sum(b -> b.id * run_blueprint(b, 24, (0,0,0,0), (1,0,0,0)), parse_line.(readlines(infile)))
part2(infile) = prod(b -> run_blueprint(b, 32, (0,0,0,0), (1,0,0,0)), parse_line.(readlines(infile))[1:3])
part2test(infile) = map(b -> run_blueprint(b, 32, (0,0,0,0), (1,0,0,0)), parse_line.(readlines(infile)))

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2test("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
