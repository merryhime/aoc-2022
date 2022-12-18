mutable struct Monkey
    items::Vector{Int}
    op
    divisible_by::Int
    true_monkey::Int
    false_monkey::Int
    inspect_count::Int
end

function parse_file(infile)
    result = Monkey[]
    for m ∈ Iterators.partition(readlines(infile), 7)
        items = parse.(Int, split(m[2][19:end], ","))
        opop = m[3][24]
        arg = m[3][26:end]
        divisible_by = parse(Int, m[4][22:end])
        true_ = parse(Int, m[5][30:end]) + 1
        false_ = parse(Int, m[6][31:end]) + 1
        op = nothing
        if arg == "old"
            if opop == '*'
                op = x -> x * x
            else
                op = x -> x + x
            end
        else
            arg = parse(Int, arg)
            if opop == '*'
                op = x -> x * arg
            else
                op = x -> x + arg
            end
        end
        push!(result, Monkey(items, op, divisible_by, true_, false_, 0))
    end
    result
end

divby3 = true
modval = nothing

function inspect_item(monkeys, m)
    item = popfirst!(monkeys[m].items)
    item = monkeys[m].op(item)
    if divby3
        item = item ÷ 3
    end
    item = item % modval
    if item % monkeys[m].divisible_by == 0
        push!(monkeys[monkeys[m].true_monkey].items, item)
    else
        push!(monkeys[monkeys[m].false_monkey].items, item)
    end
    monkeys[m].inspect_count = monkeys[m].inspect_count + 1
end

function do_round(monkeys)
    for m ∈ 1:length(monkeys)
        while !isempty(monkeys[m].items)
            inspect_item(monkeys, m)
        end
    end
end

function part1(infile)
    monkeys = parse_file(infile)
    global divby3 = true
    global modval = prod(map(x -> x.divisible_by, monkeys))
    for i ∈ 1:20
        do_round(monkeys)
    end
    prod(Iterators.take(reverse(sort(map(x -> x.inspect_count, monkeys))), 2))
end
function part2(infile)
    monkeys = parse_file(infile)
    global divby3 = false
    global modval = prod(map(x -> x.divisible_by, monkeys))
    for i ∈ 1:10000
        do_round(monkeys)
    end
    prod(Iterators.take(reverse(sort(map(x -> x.inspect_count, monkeys))), 2))
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
