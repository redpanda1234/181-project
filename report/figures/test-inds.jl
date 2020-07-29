using PGFPlotsX

function get_diff_ind(as, bs)
    for (i, (a,b)) in enumerate(zip(as, bs))
        if a != b
            # @show a,b, i
            return i
        end
    end
    return "oops"
end

function box_diffs(acol, bcol, n, h, label)
    out_str = ""
    out_str = string(out_str, "  \\node[dashed, dash pattern={on 3pt off 5pt}, draw=$(acol), draw opacity=.5] () at ($(n), $(h)) {\\large \$\\phantom{$(label)} \$};\n")
    out_str = string(out_str, "  \\node[dashed, dash pattern={on 3pt off 5pt}, dash phase=4pt, draw=$(bcol), draw opacity=.5] () at ($(n), $(h)) {\\large \$\\phantom{$(label)} \$};\n")
    return out_str
end

function gen_bits(n)
    xs = Array{Int, 1}(undef, n)
    ys = Array{Int, 1}(undef, n)
    zs = Array{Int, 1}(undef, n)

    n_xy = 0
    n_xz = 0
    n_yz = 0
    while true
        for i in 1:n
            xs[i] = convert(Int, 5*round(rand()))
            ys[i] = convert(Int, 5*round(rand()))
            zs[i] = convert(Int, 5*round(rand()))
        end

        n_xy = get_diff_ind(xs, ys)
        n_xz = get_diff_ind(xs, zs)
        n_yz = get_diff_ind(ys, zs)

        n_list = [n_xy, n_xz, n_yz]
        if "oops" in n_list
            continue
        elseif (n_xy != n_xz) & (n_xy != n_yz) & (n_yz != n_xz)
            @show n_xy
            @show n_xz
            @show n_yz
            break
        else
            a = 1/(2^n_xy)
            b = 1/(2^n_xz)
            c = 1/(2^n_yz)

            # @show a, b, c
            bool1 = a > (b + c)
            bool2 = b > (a + c)
            bool3 = c > (a + b)

            if bool1 | bool2 | bool3
                @show n_xy
                @show n_xz
                @show n_yz
                break
            end
        end



        # if a > (b + c)
        #     @show n_xy
        #     @show n_xz
        #     @show n_yz
        #     break
        # elseif b > (a + c)
        #     @show n_xy
        #     @show n_xz
        #     @show n_yz
        #     break
        # elseif c > (a + b)
        #     @show n_xy
        #     @show n_xz
        #     @show n_yz
        #     break
        # end

        # if (min(n_list...) > 3) & ((max(n_list...) - min(n_list...)) > 3)
        #     # if (xs != ys) & (ys != zs) & (xs != zs)
        #         break
        #     # end
        # end

    end

    println("AKSd")

    # @show xs[n_xy]


    # Height of x terms
    x_h = 1
    y_h = 0
    z_h = -1



    out_str_main = "\\documentclass{standalone}\n\\usepackage{tikz}\n\\begin{document}\n\\begin{tikzpicture}\n  \\def\\xcol{blue!60!white}\n  \\def\\ycol{green!85!black}\n  \\def\\zcol{red!65!white}\n  \\node[\\xcol] (xl) at (0, 1) {\\Large \$x:\$};\n  \\node[yshift=-1.5pt, \\ycol] (yl) at (0, 0) {\\Large \$y:\$};\n  \\node[\\zcol] (zl) at (0, -1) {\\Large \$z:\$};\n"

    out_str_pairwise = out_str_main

    for (i, (x,y,z)) in enumerate(zip(xs, ys, zs))
        out_str_main = string(out_str_main, "  \\node[\\xcol] (x$(i)) at ($(i), $(x_h)) {\\large \$$(x)\$};\n")
        out_str_main = string(out_str_main, "  \\node[\\ycol] (y$(i)) at ($(i), $(y_h)) {\\large \$$(y)\$};\n")
        out_str_main = string(out_str_main, "  \\node[\\zcol] (z$(i)) at ($(i), $(z_h)) {\\large \$$(z)\$};\n")
    end

    x_boxed = string(box_diffs("\\xcol", "\\ycol", n_xy, x_h, xs[n_xy]),
                     box_diffs("\\xcol", "\\zcol", n_xz, x_h, xs[n_xz]))


    y_boxed = string(box_diffs("\\ycol", "\\xcol", n_xy, y_h, ys[n_xy]),
                     box_diffs("\\ycol", "\\zcol", n_yz, y_h, ys[n_yz]))

    z_boxed = string(box_diffs("\\zcol", "\\xcol", n_xz, z_h, ys[n_xz]),
                     box_diffs("\\zcol", "\\ycol", n_yz, z_h, ys[n_yz]))

    out_str_main = string(out_str_main, x_boxed, y_boxed, z_boxed)






    out_str_main = string(out_str_main, "\\end{tikzpicture}\n\\end{document}")

    open("test-inds.tex", "w") do io
        write(io, out_str_main)
    end;

    run(`pdflatex test-inds.tex`);


    # return out_str_main

end
