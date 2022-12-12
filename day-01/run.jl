function group_by_blank_lines(array)
    return foldl(
        function (a, b)
            if b == ""
                push!(a, [])
            else
                push!(a[end], b)
            end
            a
        end, array; init=[Vector{String}()])
end

function part1(infile)
    elves = group_by_blank_lines(readlines(infile))
    elves = map(x -> sum(parse.(Int64, x)), elves)
    max(elves...)
end

function part2(infile)
    elves = group_by_blank_lines(readlines(infile))
    elves = map(x -> sum(parse.(Int64, x)), elves)
    sort!(elves)
    reverse!(elves)
    sum(elves[1:3])
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
