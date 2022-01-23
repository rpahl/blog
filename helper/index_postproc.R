
repair_index_file = function(file = "index.xml")
{
    root = dirname(file)
    lines = readLines("index.xml")
    postdirs = basename(list.dirs(file.path(root, "posts")))[-1]

    iBroken = grep(pattern = "r-some-blog//", fixed = TRUE, x = lines)
    lines_with_bad_link = lines[iBroken]

    repair_bad_link = function(x) {

        # Remove redundant slash
        res = sub("r-some-blog//",
                  replacement = "r-some-blog/",
                  x = x,
                  fixed = TRUE)

        # Add missing slash
        postname = names(Filter(sapply(postdirs,
                                       FUN = grepl, x = x, fixed = TRUE),
                                f = isTRUE)
        )
        stopifnot(length(postname) == 1)

        sub(pattern = postname,
            replacement = paste0(postname, "/"),
            x = res,
            fixed = TRUE)
    }

    repairedLines = as.character(sapply(lines_with_bad_link, repair_bad_link))
    lines[iBroken] = repairedLines
    writeLines(lines, file)
}


