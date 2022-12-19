# Shapes:

# ####

# .#.
# ###
# .#.

# ..#
# ..#
# ###

# #
# #
# #
# #

# ##
# ##

const Pos = Tuple{Int, Int}

struct Shape
    points::Vector{Pos}
    width::Int
    height::Int
end

const shapes = Shape[
    Shape(Pos[(0, 0), (1, 0), (2, 0), (3, 0)], 4, 1),
    Shape(Pos[(0, 1), (1, 1), (2, 1), (1, 0), (1, 2)], 3, 3),
    Shape(Pos[(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)], 3, 3),
    Shape(Pos[(0, 0), (0, 1), (0, 2), (0, 3)], 1, 4),
    Shape(Pos[(0, 0), (1, 0), (0, 1), (1, 1)], 2, 2),
]

const start_x = 2
const start_y_gap = 3
const screen_width = 7
const move_left = (-1, 0)
const move_right = (1, 0)
const move_down = (0, -1)

mutable struct BoardState
    set::Set{Pos}
    dirlist::Iterators.Stateful
    shapelist::Iterators.Stateful
    tallest::Int
end

points_at(s::Shape, position::Pos) = [position .+ p for p ∈ s.points]
valid_position(state::BoardState, s::Shape, position::Pos) = !any([p ∈ state.set for p ∈ points_at(s, position)])

function drop_piece(state::BoardState, s::Shape)
    position = (start_x, start_y_gap + state.tallest)
    while true
        dir = popfirst!(state.dirlist)
        new_position = position .+ (dir == '<' ? move_left : move_right)
        if new_position[1] < 0 || new_position[1] + s.width > screen_width || !valid_position(state, s, new_position)
            new_position = position
        end
        position = new_position
        new_position = position .+ move_down
        if new_position[2] < 0 || !valid_position(state, s, new_position)
            push!(state.set, points_at(s, position)...)
            state.tallest = max(state.tallest, position[2] + s.height)
            return
        end
        position = new_position
    end
end

function drop_pieces(state::BoardState, count::Int)
    for i ∈ 1:count
        drop_piece(state, popfirst!(state.shapelist))
    end
end

function part1(infile)
    dirlist = Iterators.Stateful(Iterators.cycle(collect(read(infile, String))))
    shapelist = Iterators.Stateful(Iterators.cycle(shapes))
    state = BoardState(Set(), dirlist, shapelist, 0)
    drop_pieces(state, 2022)
    state.tallest
end

function part2(infile)
    dirlist = Iterators.Stateful(Iterators.cycle(collect(read(infile, String))))
    shapelist = Iterators.Stateful(Iterators.cycle(shapes))
    state = BoardState(Set(), dirlist, shapelist, 0)
    drop_pieces(state, 1000000000000)
    state.tallest
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
