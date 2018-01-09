### Scenario
<p>You are a team of data journalists at a major online news organization. The news room staff has taken an interest in Tennessee, and has asked your team to develop a picture of Tennesseans and how they differ across (and within) counties, particularly in regard to socioeconomic factors like education and income.</p>
<p>Your assignment is to learn more about whether educational factors are related to income for Tennesseans.</p>

#### Steps
  1. Read, clean, and join the IRS, Education, and Zip Code data.
     - Use tidyverse "verbs" </br>

     mutate() adds new variables that are functions of existing variables </br>
     select() picks variables based on their names. </br>
     filter() picks cases based on their values. </br>
     summarise() reduces multiple values down to a single summary. </br>
     arrange() changes the ordering of the rows. </br>

     - Use purrr when applicable </br>

     `#map
       map_chr(c(5, 4, 3, 2, 1), function(x){
         c("one", "two", "three", "four", "five")[x]
         })
    [1] "five" "four" "three" "two" "one"

    map_lgl(c(1, 2, 3, 4, 5), function(x){
      x > 3
    })
    [1] FALSE FALSE FALSE TRUE TRUE

    map_if(1:5, function(x){
      x %% 2 == 0
      },
      function(y){
      y^2
      }) %>% unlist()
    [1] 1 4 3 16 5

    map_at(seq(100, 500, 100), c(1, 3, 5), function(x){
      x - 10
    }) %>% unlist()
    [1] 90 200 290 400 490

    map2_chr(letters, 1:26, paste)
     [1] "a 1" "b 2" "c 3" "d 4" "e 5" "f 6" "g 7" "h 8" "i 9" "j 10"
    [11] "k 11" "l 12" "m 13" "n 14" "o 15" "p 16" "q 17" "r 18" "s 19" "t 20"
    [21] "u 21" "v 22" "w 23" "x 24" "y 25" "z 26"

    pmap_chr(list(
      list(1, 2, 3),
      list("one", "two", "three"),
      list("uno", "dos", "tres")
    ), paste)
    [1] "1 one uno" "2 two dos" "3 three tres"

    # reduce

    reduce(c(1, 3, 5, 7), function(x, y){
      message("x is ", x)
      message("y is ", y)
      message("")
      x + y
    })
    x is 1
    y is 3

    x is 4
    y is 5

    x is 9
    y is 7

    [1] 16

    reduce(letters[1:4], function(x, y){
      message("x is ", x)
      message("y is ", y)
      message("")
      paste0(x, y)
    })
    x is a
    y is b

    x is ab
    y is c

    x is abc
    y is d

    [1] "abcd"

    reduce_right(letters[1:4], function(x, y){
      message("x is ", x)
      message("y is ", y)
      message("")
      paste0(x, y)
    })
    x is d
    y is c

    x is dc
    y is b

    x is dcb
    y is a

    [1] "dcba"

    # search

    contains(letters, "a")
    [1] TRUE
    contains(letters, "A")
    [1] FALSE

    detect(20:40, function(x){
      x > 22 && x %% 2 == 0
    })
    [1] 24

    detect_index(20:40, function(x){
      x > 22 && x %% 2 == 0
    })
    [1] 5

    # filter

    keep(1:20, function(x){
      x %% 2 == 0
    })
     [1] 2 4 6 8 10 12 14 16 18 20

    discard(1:20, function(x){
      x %% 2 == 0
    })
     [1] 1 3 5 7 9 11 13 15 17 19

    every(1:20, function(x){
      x %% 2 == 0
    })
    [1] FALSE
    some(1:20, function(x){
      x %% 2 == 0
    })
    [1] TRUE

    # compose()

    n_unique <- compose(length, unique)
    # The composition above is the same as:
    # n_unique <- function(x){
    # length(unique(x))
    # }

    rep(1:5, 1:5)
     [1] 1 2 2 3 3 3 4 4 4 4 5 5 5 5 5

    n_unique(rep(1:5, 1:5))
    [1] 5`

  2. Do some exploratory data analysis.
    - Use ggplot2 for visualizations
    - Use the cor() function to look for correlations
    - Use comments throughout to articulate the thinking that has informed your choices

  3. Use your exploratory data analysis as the foundation to fit a linear regression model.
