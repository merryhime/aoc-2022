neighbours = [
    (-1, 0, 0), (+1, 0, 0),
    (0, -1, 0), (0, +1, 0),
    (0, 0, -1), (0, 0, +1),
]

read_input(infile) = map(l -> parse.(Int, split(l, ",")), readlines(infile))

function part1(infile)
    input = read_input(infile)
    blob = Set(input)
    surface = filter(s -> s ∉ blob, reduce(vcat, map(p -> [p .+ n for n ∈ neighbours], input)))
    length(surface)
end

function part2(infile)
    input = read_input(infile)
    blob = Set(input)
    surface = filter(s -> s ∉ blob, reduce(vcat, map(p -> [p .+ n for n ∈ neighbours], input)))

    x_max = maximum(s -> s[1], surface) + 4
    y_max = maximum(s -> s[2], surface) + 4
    z_max = maximum(s -> s[3], surface) + 4

    offset = (2,2,2)

    air = zeros(Bool, x_max, y_max, z_max)
    frontier = Set([[1, 1, 1]])
    while length(frontier) ≠ 0
        frontier = filter(f -> checkbounds(Bool, air, (f .+ offset)...) && air[(f .+ offset)...] == 0 && f ∉ blob, reduce(∪, map(p -> Set([p .+ n for n ∈ neighbours]), collect(frontier))))
        for f ∈ collect(frontier)
            air[(f .+ offset)...] = true
        end
    end

    count([air[(s .+ offset)...] for s ∈ surface])
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
