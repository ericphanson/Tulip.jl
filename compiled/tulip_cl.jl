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
    hello afiro.mps
    ```
=#
module Tulip_cl

using LinearAlgebra

import Tulip
TLP = Tulip

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    n = length(ARGS)
    if n == 0
        println("Please enter the name of the instance.")
        return 0    
    end

    BLAS.set_num_threads(1)

    # Read model and solve
    finst = ARGS[1]

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
