dir = Dict{Char, Tuple{Int64, Int64}}(
    'U' => (0, -1),
    'D' => (0, +1),
    'L' => (-1, 0),
    'R' => (+1, 0),
)

function simulate(infile, N)
    rope = [(0,0) for i ∈ 1:N]
    tail = Set([(0,0)])
    for cmd ∈ readlines(infile)
        for i ∈ 1:parse(Int64, cmd[3:end])
            rope[1] = rope[1] .+ dir[cmd[1]]
            for j ∈ 2:N
                diff = rope[j-1] .- rope[j]
                if max(abs.(diff)...) ≥ 2
                    rope[j] = rope[j] .+ sign.(diff)
                end
            end
            push!(tail, rope[end])
        end
    end
    length(tail)
end

part1(infile) = simulate(infile, 2)
part2(infile) = simulate(infile, 10)

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
