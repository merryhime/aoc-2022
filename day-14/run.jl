parse_line(line) = map(x -> parse.(Int, split(x, ",")), split(line, " -> "))
insert_line(m, (a, b)) = [m[i] = '#' for i ∈ Iterators.product(min(a[1], b[1]):max(a[1], b[1]), min(a[2], b[2]):max(a[2], b[2]))]
insert_rock(m, line) = insert_line.(Ref(m), Iterators.zip(line, Iterators.drop(line, 1)))

function drop_sand(m, max_y)
    location = (500, 0)
    while location[2] < max_y
        if !haskey(m, location .+ (0, 1))
            location = location .+ (0, 1)
        elseif !haskey(m, location .+ (-1, 1))
            location = location .+ (-1, 1)
        elseif !haskey(m, location .+ (1, 1))
            location = location .+ (1, 1)
        else
            m[location] = 'o'
            return true
        end
    end
    m[location] = 'o'
    return false
end

function part1(infile)
    m = Dict{Tuple{Int, Int}, Char}()
    insert_rock.(Ref(m), parse_line.(readlines(infile)))
    while drop_sand(m, 500)
    end
    count(values(m) .== 'o') - 1
end
function part2(infile)
    m = Dict{Tuple{Int, Int}, Char}()
    insert_rock.(Ref(m), parse_line.(readlines(infile)))
    max_y = maximum(map(x -> x[2], collect(keys(m)))) + 1
    while !haskey(m, (500, 0))
        drop_sand(m, max_y)
    end
    count(values(m) .== 'o')
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
