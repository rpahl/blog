
repair_links = function(file = "index.xml")
{
    root = dirname(file)
    lines = readLines(file)
    postdirs = basename(list.dirs(file.path(root, "posts")))[-1]

    iBroken = grep(pattern = "r-some-blog//", fixed = TRUE, x = lines)
    if (length(iBroken) == 0)
        return()

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


read_Rmd_header = function(file)
{
    lines = readLines(file)
    dash3 = grep(pattern = "---", x = lines, fixed = TRUE)
    iStart = dash3[1] + 1
    iEnd = dash3[2] - 1
    yaml::read_yaml(text = lines[iStart:iEnd])
}


add_description_from_rmd_to_index_file = function(rmdFile, indexFile)
{
    rmdHeader = read_Rmd_header(rmdFile)
    index = readLines(file)
    len = length(index)

    # Find description tag in index file
    titleElement = paste0("<title>", rmdHeader[["title"]], "</title>")
    titleLineNumber = grep(titleElement, index, fixed = TRUE)

    ii = titleLineNumber +
        grep("<description>", index[titleLineNumber:len], fixed = TRUE)[1] - 1

    # Add description from Rmd file
    updatedIndex = c(index[1:ii], rmdHeader[["description"]], index[(ii+1):len])
    writeLines(updatedIndex, file)
}



postproc_index_file = function(file = "index.xml")
{
    repair_links(file)

    wd = dirname(file)
    posts_folder = file.path(wd, "..", "_posts")

    rmdFiles = list.files(posts_folder,
                          recursive = TRUE,
                          full.names = TRUE,
                          pattern = "*.Rmd")

    for (rmdFile in rmdFiles)
        add_description_from_rmd_to_index_file(rmdFile, indexFile = file)
}

