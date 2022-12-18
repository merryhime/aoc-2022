read_grid(infile) = hcat(collect.(readlines(infile))...)
neighbours(node, m) = filter(x -> checkbounds(Bool, m, x), Ref(node) .+ [CartesianIndex(0, 1), CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(-1, 0)])

function floodfill(m, S, E)
    path = zeros(Int, size(m))
    path[S] .= 1
    curr_dist = 1
    while path[E] == 0
        frontier = findall(==(curr_dist), path)
        curr_dist = curr_dist + 1
        for node ∈ frontier
            for neighbour ∈ neighbours(node, m)
                if m[neighbour] > m[node] + 1
                    continue
                elseif path[neighbour] == 0
                    path[neighbour] = curr_dist
                end
            end
        end
    end
    path[E] - 1
end

function part1(infile)
    m = read_grid(infile)
    S = findfirst(==('S'), m)
    E = findfirst(==('E'), m)
    m[S] = 'a'
    m[E] = 'z'
    floodfill(m, [S], E)
end
function part2(infile)
    m = read_grid(infile)
    S = findfirst(==('S'), m)
    E = findfirst(==('E'), m)
    m[S] = 'a'
    m[E] = 'z'
    floodfill(m, findall(==('a'), m), E)
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
