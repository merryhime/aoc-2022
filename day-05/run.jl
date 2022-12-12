parse_move(line) = (@Scanf.scanf line "move %i from %i to %i" Int Int Int)[2:end]

rows(M) = (view(M, i, :) for i in 1:size(M, 1))

function get_state(infile)
    header = collect(Iterators.takewhile(!isempty, readlines(infile)))
    L = max(length.(header)...)
    filter.(!isspace, rows(reduce(hcat, reverse(collect.(rpad.(header, L)))[2:end])[2:4:end, :]))
end

function execute_move1(state, (count, from, to))
    for i = 1:count
        push!(state[to], pop!(state[from]))
    end
end

function execute_move2(state, (count, from, to))
    append!(state[to], splice!(state[from], length(state[from])-count+1:length(state[from])))
end

function part1(infile)
    state = get_state(infile)
    moves = Iterators.drop(Iterators.dropwhile(!isempty, readlines(infile)), 1)
    for move = moves
        execute_move1(state, parse_move(move))
    end
    join(map(last, state))
end

function part2(infile)
    state = get_state(infile)
    moves = Iterators.drop(Iterators.dropwhile(!isempty, readlines(infile)), 1)
    for move = moves
        execute_move2(state, parse_move(move))
    end
    join(map(last, state))
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
