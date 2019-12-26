#=
    This is the entry point for PackageCompiler.
    To make this into an executable, run the following (from Tulip root directory):
    ```julia
    using PackageCompiler
    build_executable("compiled/tulip_cl.jl", snoopfile="compiled/snoop.jl", "tulip_cl")
    ```
    Make sure that the right version of Tulip is loaded in Julia.
    The executable is called as follows:
    ```bash
    tulip_cl --Threads 1 --TimeLimit 1.0 afiro.mps
    ```
=#
module Tulip_cl

using ArgParse

function parse_commandline(cl_args)

    s = ArgParseSettings()

    @add_arg_table s begin
        "--Threads"
            help = "Maximum number of threadss"
            arg_type = Int
            default = length(Sys.cpu_info())
        "--TimeLimit"
            help = "Time limit in seconds"
            arg_type = Float64
            default = Inf
        "finst"
            help = "Name of instance file in free MPS format"
            required = true
    end

    return parse_args(cl_args, s)
end

import Tulip
TLP = Tulip

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint

    args = parse_commandline(ARGS)

    # Read model and solve
    finst = args["finst"]

    m = Tulip.Model{Float64}()
    try
        t = @elapsed TLP.readmps!(m, finst)
        println("Reading time (s): $t")
    catch err
        println("Error encountered while reading file.")
        println(err)
        return 0
    end

    m.env.verbose = true
    m.env.threads = args["Threads"]
    m.env.time_limit = args["TimeLimit"]

    try
        TLP.optimize!(m)
    catch err
        println("Error encoutered while solving the model.")
        println(err)
        return 0
    end

    return 0
end

end