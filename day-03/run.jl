function split(bag)
    i = length(bag) ÷ 2
    [bag[1:i], bag[i+1:end]]
end

columns(M) = (view(M, :, i) for i in 1:size(M, 2))

function priority(item)
    if item >= 'a' && item <= 'z'
        Int(item) - Int('a') + 1
    elseif item >= 'A' && item <= 'Z'
        Int(item) - Int('A') + 27
    else
        @assert false
    end
end

function part1(infile)
    bags = split.(readlines(infile))
    common = map(x -> x[1] ∩ x[2], bags)
    ps = map(x -> priority(x[1]), common)
    sum(ps)
end

function part2(infile)
    groups = columns(reshape(readlines(infile), 3, :))
    common = map(x -> reduce(∩, x), groups)
    ps = map(x -> priority(x[1]), common)
    sum(ps)
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
