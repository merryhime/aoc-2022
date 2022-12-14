function scan(infile)
    path = String[]
    sizes = Dict{Vector{String}, Int64}()
    for line = readlines(infile)
        if startswith("\$ cd ")(line)
            d = line[6:end]
            if d == "/"
                path = String[]
            elseif d == ".."
                pop!(path)
            else
                push!(path, d)
            end
        elseif line == "\$ ls"
            # do nothing
        elseif startswith("dir ")(line)
            # do nothing
        else
            sz = parse(Int64, split(line)[1])
            for p = collect.(Iterators.take.(Ref(path), 0:length(path)))
                sizes[p] = get(sizes, p, 0) + sz
            end
        end
    end
    sizes
end

part1(infile) = sum(Iterators.filter(x -> x ≤ 100000, values(scan(infile))))

function part2(infile)
    sizes = scan(infile)
    required_space = sizes[String[]] - 40000000
    l = sort(collect(values(sizes)))
    l[findfirst(x -> x ≥ required_space, l)]
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
