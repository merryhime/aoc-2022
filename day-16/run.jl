import Scanf
using ThreadedIterables

struct Valve
    name::String
    flow_rate::Int
    next::Vector{String}
end

function parse_valve(line)
    (_, name, flow_rate) = @Scanf.scanf line "Valve %s has flow rate=%i" String Int
    i = findfirst("valve", line).stop + 2
    Valve(name, flow_rate, strip.(split(line[i:end], ",")))
end
parse_file(infile) = Dict(map(x -> (x.name => x), parse_valve.(readlines(infile))))

struct PrecomputedValve
    flow_rate::Int
    next::Vector{Int}
end

function precompute_valve(valves::Dict{String, Valve}, names::Vector{String}, v::String)
    precomp_next = zeros(Int, length(names))
    visited = Set([v])
    frontier = [v]
    cost = 1
    while !isempty(frontier)
        frontier = reduce(vcat, map(f -> valves[f].next, frontier))
        filter!(∉(visited), frontier)
        if !isempty(frontier)
            push!(visited, frontier...)
        end
        for f ∈ frontier
            if valves[f].flow_rate != 0
                precomp_next[findfirst(==(f), names)] = cost
            end
        end
        cost = cost + 1
    end
    PrecomputedValve(valves[v].flow_rate, precomp_next)
end

function precompute(valves::Dict{String, Valve})
    names = collect(keys(valves))
    sort!(names)
    @assert names[1] == "AA"
    filter!(n -> valves[n].flow_rate != 0 || n == "AA", names)

    result = Vector{PrecomputedValve}()
    for n ∈ names
        push!(result, precompute_valve(valves, names, n))
    end
    result
end

mutable struct State
    closed::Int
    ticks::Int
    position::Int
    current_flow_rate::Int
    accumulated_flow_rate::Int
end

function step_state(s::State, valves::Vector{PrecomputedValve})
    if s.ticks == 30
        return s
    end

    nexts = State[]
    pos = s.position
    closed = s.closed

    while closed != 0
        next_pos = trailing_zeros(closed) + 1
        closed = closed & ~(1 << (next_pos - 1))
        cost = valves[s.position].next[next_pos]
        next = deepcopy(s)
        next.accumulated_flow_rate = next.accumulated_flow_rate + next.current_flow_rate * (cost + 1)
        next.ticks = next.ticks + cost + 1
        next.current_flow_rate = next.current_flow_rate + valves[next_pos].flow_rate
        next.position = next_pos
        next.closed = next.closed & ~(1 << (next_pos - 1))
        if next.ticks ≤ 30
            push!(nexts, step_state(next, valves))
        end
    end

    if length(nexts) == 0
        next = deepcopy(s)
        remaining_ticks = 30 - next.ticks
        next.accumulated_flow_rate = next.accumulated_flow_rate + next.current_flow_rate * remaining_ticks
        next.ticks = next.ticks + remaining_ticks
        push!(nexts, step_state(next, valves))
    end

    argmax(s -> s.accumulated_flow_rate, nexts)
end

function part1(infile)
    valves = precompute(parse_file(infile))
    s = State((1 << length(valves)) - 2, 0, 1, 0, 0)
    step_state(s, valves)
end

mutable struct State2
    closed::Int
    my_ticks::Int
    my_position::Int
    elephant_ticks::Int
    elephant_position::Int
    my_current_flow_rate::Int
    my_accumulated_flow_rate::Int
    elephant_current_flow_rate::Int
    elephant_accumulated_flow_rate::Int
end

function step_state2(s::State2, valves::Vector{PrecomputedValve})
    if s.my_ticks == 30 && s.elephant_ticks == 30
        return s
    end

    nexts = State2[]
    pos = s.my_position
    closed = s.closed

    if s.my_ticks ≤ s.elephant_ticks
        while closed != 0
            next_pos = trailing_zeros(closed) + 1
            closed = closed & ~(1 << (next_pos - 1))
            cost = valves[s.my_position].next[next_pos]
            if s.my_ticks + cost + 1 ≤ 30
                next = deepcopy(s)
                next.my_accumulated_flow_rate = next.my_accumulated_flow_rate + next.my_current_flow_rate * (cost + 1)
                next.my_ticks = next.my_ticks + cost + 1
                next.my_current_flow_rate = next.my_current_flow_rate + valves[next_pos].flow_rate
                next.my_position = next_pos
                next.closed = next.closed & ~(1 << (next_pos - 1))
                push!(nexts, step_state2(next, valves))
            end
        end

        if length(nexts) == 0
            next = deepcopy(s)
            remaining_ticks = 30 - next.my_ticks
            next.my_accumulated_flow_rate = next.my_accumulated_flow_rate + next.my_current_flow_rate * remaining_ticks
            next.my_ticks = next.my_ticks + remaining_ticks
            push!(nexts, step_state2(next, valves))
        end
    else
        while closed != 0
            next_pos = trailing_zeros(closed) + 1
            closed = closed & ~(1 << (next_pos - 1))
            cost = valves[s.elephant_position].next[next_pos]
            if s.elephant_ticks + cost + 1 ≤ 30
                next = deepcopy(s)
                next.elephant_accumulated_flow_rate = next.elephant_accumulated_flow_rate + next.elephant_current_flow_rate * (cost + 1)
                next.elephant_ticks = next.elephant_ticks + cost + 1
                next.elephant_current_flow_rate = next.elephant_current_flow_rate + valves[next_pos].flow_rate
                next.elephant_position = next_pos
                next.closed = next.closed & ~(1 << (next_pos - 1))
                push!(nexts, step_state2(next, valves))
            end
        end

        if length(nexts) == 0
            next = deepcopy(s)
            remaining_ticks = 30 - next.elephant_ticks
            next.elephant_accumulated_flow_rate = next.elephant_accumulated_flow_rate + next.elephant_current_flow_rate * remaining_ticks
            next.elephant_ticks = next.elephant_ticks + remaining_ticks
            push!(nexts, step_state2(next, valves))
        end
    end

    argmax(s -> s.my_accumulated_flow_rate + s.elephant_accumulated_flow_rate, nexts)
end

function part2(infile)
    valves = precompute(parse_file(infile))
    s = State2((1 << length(valves)) - 2, 4, 1, 4, 1, 0, 0, 0, 0)
    step_state2(s, valves)
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
