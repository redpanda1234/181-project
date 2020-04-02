using ProgressMeter
using Plots
pgfplotsx()

# Manneville map with starting value x₀ ∈ [0,1], parameter z > 1, and
# (number of iterations) n ∈ N
function mville(x₀, z, n)
    # Initialize empty array of the desired length
    out_vals = Array{T where T <: Number, 1}(undef, n)

    # Initialize the value of our dynamical system
    x = x₀
    @showprogress 1 for i in 1:n
        out_vals[i] = x
        x = (x + x^z) % 1 # The manneville map
    end

    return out_vals
end




function main()

    n = 500

    xz_pairs = [
        (.5, 1.5),
        (.5, 2),
        (.5, 2.5),
    ]

    for (i, (x,z)) in enumerate(xz_pairs)
        x = x + 1e-20
        plot(mville(x, z, n), title=string("Plot for \$x_0 = ", x, ", z=", z, ", n = ", n, "\$"),
             linewidth=.5)
        savefig(string(i, ".pdf"))
    end



end
