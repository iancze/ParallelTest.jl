#!/usr/bin/env julia

# Lets add workers programatically, and see if they distribute to different cores.


using ArgParse

s = ArgParseSettings()
@add_arg_table s begin
    # "--opt1"
    # help = "an option with an argument"
    "--cpus"
    help = "Which CPUS to add"
    arg_type = Array{Int, 1}
end

parsed_args = parse_args(ARGS, s)

cpus = parsed_args["cpus"]
p = length(cpus)

using ClusterManagers

addprocs(LocalAffinityManager(;affinities=cpus))


nchild = nworkers()
println("Workers allocated ", nchild)
println("Total workers ", workers())

println("Total processes ", nprocs())

@everywhere function print_cpus()
    run(pipeline(`ps -eo pid,psr,pcpu,cmd`, `grep julia`))
end

println("Before map")
print_cpus()

@everywhere function pcpus(mat)
    println("In map")
    print_cpus()
    svd(mat)
end

M = [rand(1000,1000) for i=1:p]

pmap(pcpus, M)

println("After map.")
print_cpus()
