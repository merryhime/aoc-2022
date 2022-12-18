parse_packet(s) = Meta.eval(Meta.parse(s))
compare(left::Int, right::Int) = cmp(<, left, right)
compare(left::Int, right::Vector) = compare([left], right)
compare(left::Vector, right::Int) = compare(left, [right])
function compare(left::Vector, right::Vector)
    for (l, r) ∈ Iterators.zip(left, right)
        c = compare(l, r)
        c != 0 && return c
    end
    return compare(length(left), length(right))
end

function part1(infile)
    c = [compare(left, right) for (left, right) ∈ Iterators.partition(parse_packet.(readlines(infile)), 3)]
    sum(findall(c .== -1))
end
function part2(infile)
    packets = filter(!isnothing, parse_packet.(readlines(infile)))
    push!(packets, [[2]], [[6]])
    packets = sort(packets; lt=(x,y) -> compare(x,y)==-1)
    i2 = findfirst(compare.(packets, Ref([[2]])) .== 0)
    i6 = findfirst(compare.(packets, Ref([[6]])) .== 0)
    i2 * i6
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
