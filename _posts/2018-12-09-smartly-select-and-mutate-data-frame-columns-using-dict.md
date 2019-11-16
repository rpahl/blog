---
title: "Smartly select and mutate data frame columns, using dict"


date: "December 09, 2018"
layout: post
---


<section class="main-content">
<div id="motivation" class="section level2">
<h2>Motivation</h2>
<p>The <a href="https://CRAN.R-project.org/package=dplyr">dplyr</a> functions <code>select</code> and <code>mutate</code> nowadays are commonly applied to perform <code>data.frame</code> column operations, frequently combined with <a href="https://CRAN.R-project.org/package=magrittr">magrittr</a>s forward <code>%&gt;%</code> pipe. While working well interactively, however, these methods often would require additional checking if used in “serious” code, for example, to catch column name clashes.</p>
<p>In principle, the <a href="https://cran.r-project.org/web/packages/container/index.html">container</a> package provides a <code>dict</code>-class (resembling <a href="https://www.python.org/">Python</a>s dict type), which allows to cover these issues more easily. In its very recent update, the <a href="https://cran.r-project.org/web/packages/container/index.html">container</a> package for this reason gained an S3 method interface plus functions to convert back and forth between <code>dict</code> and <code>data.frame</code>. This can be used to extend the set of <code>data.frame</code> column operations and in this post I will show how and when they can serve as a useful alternative to <code>mutate</code> and <code>select</code>.</p>
<p>To keep matters simple, we use a tiny data table.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data &lt;-<span class="st"> </span><span class="kw">data.frame</span>(<span class="dt">x =</span> <span class="kw">c</span>(<span class="fl">0.2</span>, <span class="fl">0.5</span>), <span class="dt">y =</span> letters[<span class="dv">1</span><span class="op">:</span><span class="dv">2</span>])
data
##     x y
## 1 0.2 a
## 2 0.5 b</code></pre></div>
</div>
<div id="column-operations" class="section level2">
<h2>Column operations</h2>
<div id="add" class="section level3">
<h3>Add</h3>
<p>Let’s add a column using <code>mutate</code>.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(dplyr)
n &lt;-<span class="st"> </span><span class="kw">nrow</span>(data)

data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">mutate</span>(<span class="dt">ID =</span> <span class="dv">1</span><span class="op">:</span>n)
##     x y ID
## 1 0.2 a  1
## 2 0.5 b  2</code></pre></div>
<p>For someone not familar with the <a href="https://www.tidyverse.org/">tidyverse</a>, this code block might read somewhat odd as the column is added and <em>not</em> mutated. To add a column using <code>dict</code> simply use <code>add</code>.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(container)
data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">add</span>(<span class="st">&quot;ID&quot;</span>, <span class="dv">1</span><span class="op">:</span>n) <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
##     x y ID
## 1 0.2 a  1
## 2 0.5 b  2</code></pre></div>
<p>The intended add-operation is stated more clearly, but on the downside we also had to add some overhead. Of course, since this has to be done only at the beginning and at the end of the pipe, it will be less of an issue if multiple dict-operations are performed in between. Next, instead of ID, let’s add another numeric column <code>y</code>, which happens to “name-clash” with the already existing column.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">mutate</span>(<span class="dt">y =</span> <span class="kw">rnorm</span>(n))
##     x           y
## 1 0.2 -0.01315517
## 2 0.5  1.76574896</code></pre></div>
<p>Ooops - we have accidently overwritten the initial y-column. While this was easy to see here, it may not if the <code>data.frame</code> has a lot of columns or if column names are created automatically as part of some script. To catch this, usually some overhead is required, too.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="cf">if</span> (<span class="st">&quot;y&quot;</span> <span class="op">%in%</span><span class="st"> </span><span class="kw">colnames</span>(data)) {
    <span class="kw">stop</span>(<span class="st">&quot;column y already exists&quot;</span>)
} <span class="cf">else</span> {
    data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">mutate</span>(<span class="dt">y =</span> <span class="kw">rnorm</span>(n))
}
## Error in eval(expr, envir, enclos): column y already exists</code></pre></div>
<p>Let’s see the dict-operation in comparison.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">add</span>(<span class="st">&quot;y&quot;</span>, <span class="kw">rnorm</span>(n)) <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
## Error in x$add(key, value): key &#39;y&#39; already in Dict</code></pre></div>
<p>The name clash is catched by default and the overhead does not look so silly anymore. As a bonus, the error message still provides information about the originally <em>intended</em> add-operation.</p>
</div>
<div id="modify" class="section level3">
<h3>Modify</h3>
<p>If the intend was indeed to overwrite the value, the dict-function <code>setval</code> can be used.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">setval</span>(<span class="st">&quot;y&quot;</span>, <span class="kw">rnorm</span>(n)) <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
##     x         y
## 1 0.2 0.7980608
## 2 0.5 1.5270871</code></pre></div>
<p>As we saw above, if a column does not exist, <code>mutate</code> silently creates it for you. If this is not what you want, which means, you want to make sure something is overwritten, again, a workaround is needed.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="cf">if</span> (<span class="st">&quot;ID&quot;</span> <span class="op">%in%</span><span class="st"> </span><span class="kw">colnames</span>(data)) {
    data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">mutate</span>(<span class="dt">ID =</span> <span class="dv">1</span><span class="op">:</span>n)    
} <span class="cf">else</span> {
    <span class="kw">stop</span>(<span class="st">&quot;column ID not in data.frame&quot;</span>)
}
## Error in eval(expr, envir, enclos): column ID not in data.frame</code></pre></div>
<p>Once again, the workaround is already “built-in” in the dict-framework.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">setval</span>(<span class="st">&quot;ID&quot;</span>, <span class="dv">1</span><span class="op">:</span>n) <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
## Error in x$set(key, value, add): key &#39;ID&#39; not in Dict</code></pre></div>
<p>After all, the intend of the <code>mutate</code> function actually would be something like: <em>overwrite a column, or, create it if it does not exist</em>. If desired, this behaviour can be expressed within the dict-framework as well.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">setval</span>(<span class="st">&quot;ID&quot;</span>, <span class="dv">1</span><span class="op">:</span>n, <span class="dt">add=</span><span class="ot">TRUE</span>) <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
##     x y ID
## 1 0.2 a  1
## 2 0.5 b  2</code></pre></div>
</div>
<div id="remove" class="section level3">
<h3>Remove</h3>
<p>A common <a href="https://www.tidyverse.org/">tidyverse</a> approach to remove a column is based on the <code>select</code> function. One corresponding dict-function is <code>remove</code>.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">select</span>(<span class="op">-</span><span class="st">&quot;y&quot;</span>)
##     x
## 1 0.2
## 2 0.5

data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">remove</span>(<span class="st">&quot;y&quot;</span>) <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
##     x
## 1 0.2
## 2 0.5</code></pre></div>
<p>Let’s see what happens if the column does not exist in the first place.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">select</span>(<span class="op">-</span><span class="st">&quot;ID&quot;</span>)
## Unknown column `ID`

data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">remove</span>(<span class="st">&quot;ID&quot;</span>) <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
## Error in x$remove(key): key &#39;ID&#39; not in Dict</code></pre></div>
<p>Again, we obtain a slightly more informative error message with dict. Assume we want the column to be removed if it exist but otherwise silently ignore the command, for example:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="cf">if</span> (<span class="st">&quot;ID&quot;</span> <span class="op">%in%</span><span class="st"> </span><span class="kw">colnames</span>(data)) {
    data <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">select</span>(<span class="op">-</span><span class="st">&quot;ID&quot;</span>)    
}</code></pre></div>
<p>You may have expected this by now - the dict-framework provides a straigh-forward solution, namely, the <code>discard</code> function:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">discard</span>(<span class="st">&quot;ID&quot;</span>) <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">    </span><span class="kw">discard</span>(<span class="st">&quot;y&quot;</span>) <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">add</span>(<span class="st">&quot;z&quot;</span>, <span class="kw">c</span>(<span class="st">&quot;Hello&quot;</span>, <span class="st">&quot;World&quot;</span>)) <span class="op">%&gt;%</span>
<span class="st">    </span><span class="kw">as.data.frame</span>()
##     x     z
## 1 0.2 Hello
## 2 0.5 World</code></pre></div>
</div>
</div>
<div id="benchmark" class="section level2">
<h2>Benchmark</h2>
<p>The required additional code lines are limited but what about the computational overhead? To examine this, we benchmark some column operations using the famous ‘iris’ data set. As a hallmark reference we will also bring the <a href="https://CRAN.R-project.org/package=data.table">data.table</a> framework to the competition.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">set.seed</span>(<span class="dv">123</span>)
<span class="kw">library</span>(microbenchmark)
<span class="kw">library</span>(ggplot2)
<span class="kw">library</span>(data.table)
data &lt;-<span class="st"> </span>iris
n &lt;-<span class="st"> </span><span class="kw">nrow</span>(data)
<span class="kw">head</span>(iris)
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa</code></pre></div>
<p>For the benchmark, we add one, transform one and finally delete one column.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">bm &lt;-<span class="st"> </span><span class="kw">microbenchmark</span>(<span class="dt">control =</span> <span class="kw">list</span>(<span class="dt">order=</span><span class="st">&quot;inorder&quot;</span>), <span class="dt">times =</span> <span class="dv">100</span>,
    <span class="dt">dplyr =</span> data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">mutate</span>(<span class="dt">ID =</span> <span class="dv">1</span><span class="op">:</span>n) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">mutate</span>(<span class="dt">Species =</span> <span class="kw">as.character</span>(Species)) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">select</span>(<span class="op">-</span>Sepal.Width),
    
    <span class="dt">dict =</span> data <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">add</span>(<span class="st">&quot;ID&quot;</span>, <span class="dv">1</span><span class="op">:</span>n) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">setval</span>(., <span class="st">&quot;Species&quot;</span>, <span class="kw">as.character</span>(.<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;Species&quot;</span>))) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">remove</span>(<span class="st">&quot;Sepal.Width&quot;</span>) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">as.data.frame</span>(),
    
    <span class="st">`</span><span class="dt">[.data.table</span><span class="st">`</span> =<span class="st"> </span>data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span>
<span class="st">        </span>.[, ID <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="dv">1</span><span class="op">:</span>n] <span class="op">%&gt;%</span>
<span class="st">        </span>.[, Species <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">as.character</span>(Species)] <span class="op">%&gt;%</span>
<span class="st">        </span>.[, Sepal.Width <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="ot">NULL</span>]
)
<span class="kw">autoplot</span>(bm) <span class="op">+</span><span class="st"> </span><span class="kw">theme_bw</span>()</code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/smartly-select-and-mutate_files/figure-html/benchmark1-1.png" /><!-- --></p>
<p>Somewhat surprisingly maybe, the dict-implementation is closer to the <a href="https://CRAN.R-project.org/package=data.table">data.table</a> than to the <a href="https://CRAN.R-project.org/package=dplyr">dplyr</a> performance. Let’s examine each operation in more detail.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">bm &lt;-<span class="st"> </span><span class="kw">microbenchmark</span>(<span class="dt">control =</span> <span class="kw">list</span>(<span class="dt">order=</span><span class="st">&quot;inorder&quot;</span>), <span class="dt">times =</span> <span class="dv">100</span>,
    tbl &lt;-<span class="st"> </span><span class="kw">mutate</span>(data, <span class="dt">ID =</span> <span class="dv">1</span><span class="op">:</span>n),
    tbl &lt;-<span class="st"> </span><span class="kw">mutate</span>(tbl, <span class="dt">Species =</span> <span class="kw">as.character</span>(Species)),
    tbl &lt;-<span class="st"> </span><span class="kw">select</span>(tbl, <span class="op">-</span>Sepal.Width),
    
    dic &lt;-<span class="st"> </span><span class="kw">as.dict</span>(data),
    <span class="kw">add</span>(dic, <span class="st">&quot;ID&quot;</span>, <span class="dv">1</span><span class="op">:</span>n),
    <span class="kw">setval</span>(dic, <span class="st">&quot;Species&quot;</span>, <span class="kw">as.character</span>(dic<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;Species&quot;</span>))),
    <span class="kw">remove</span>(dic, <span class="st">&quot;Sepal.Width&quot;</span>),
    dic &lt;-<span class="st"> </span><span class="kw">as.data.frame</span>(dic),
    
    dt &lt;-<span class="st"> </span><span class="kw">as.data.table</span>(data),
    dt[, ID <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="dv">1</span><span class="op">:</span>n],
    dt[, Species <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">as.character</span>(Species)],
    dt[, Sepal.Width <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="ot">NULL</span>]
)
<span class="kw">autoplot</span>(bm) <span class="op">+</span><span class="st"> </span><span class="kw">theme_bw</span>()</code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/smartly-select-and-mutate_files/figure-html/benchmark2-1.png" /><!-- --></p>
<p>Apparently, the mutate and select operations are the slowest in comparison, I think, because both the dict and <a href="https://CRAN.R-project.org/package=data.table">data.table</a> approach work by reference while probably some copying is done in the <a href="https://CRAN.R-project.org/package=dplyr">dplyr</a> pipe. We also see that the dict-approach spends most of the computation time for the transformation back and forth between a <code>dict</code> and a <code>data.frame</code> while the actual column operations seem very efficient, even more efficient than that of <a href="https://CRAN.R-project.org/package=data.table">data.table</a>. This certainly came as a surprise to me, as the focus when developing the <a href="https://cran.r-project.org/web/packages/container/index.html">container</a> package has never been on speed but rather on providing a concise data structure. Internally the dict simply consists of a named list, so I guess this speaks for the efficiency of base R list operations. Having said that, I found that the <a href="https://CRAN.R-project.org/package=data.table">data.table</a> code can be further improved by avoiding the overhead of the <code>[.data.table</code> operator and instead use the built-in <code>set</code> function:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">bm &lt;-<span class="st"> </span><span class="kw">microbenchmark</span>(<span class="dt">control =</span> <span class="kw">list</span>(<span class="dt">order=</span><span class="st">&quot;inorder&quot;</span>), <span class="dt">times =</span> <span class="dv">100</span>,
    <span class="dt">dplyr =</span> data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">mutate</span>(<span class="dt">ID =</span> <span class="dv">1</span><span class="op">:</span>n) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">mutate</span>(<span class="dt">Species =</span> <span class="kw">as.character</span>(Species)) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">select</span>(<span class="op">-</span>Sepal.Width),
    
    <span class="dt">dict =</span> data <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">as.dict</span>() <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">add</span>(<span class="st">&quot;ID&quot;</span>, <span class="dv">1</span><span class="op">:</span>n) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">setval</span>(., <span class="st">&quot;Species&quot;</span>, <span class="kw">as.character</span>(.<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;Species&quot;</span>))) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">remove</span>(<span class="st">&quot;Sepal.Width&quot;</span>) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">as.data.frame</span>(),
    
    <span class="st">`</span><span class="dt">[.data.table</span><span class="st">`</span> =<span class="st"> </span>data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span>
<span class="st">        </span>.[, ID <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="dv">1</span><span class="op">:</span>n] <span class="op">%&gt;%</span>
<span class="st">        </span>.[, Species <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">as.character</span>(Species)] <span class="op">%&gt;%</span>
<span class="st">        </span>.[, Sepal.Width <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="ot">NULL</span>],
    
    <span class="dt">data.table.set =</span> data <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">        </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">set</span>(., <span class="dt">j=</span> <span class="st">&quot;ID&quot;</span>, <span class="dt">value =</span> <span class="dv">1</span><span class="op">:</span>n) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">set</span>(., <span class="dt">j =</span> <span class="st">&quot;Species&quot;</span>, <span class="dt">value =</span> <span class="kw">as.character</span>(.[[<span class="st">&quot;Species&quot;</span>]])) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">set</span>(., <span class="dt">j =</span> <span class="st">&quot;Sepal.Width&quot;</span>, <span class="dt">value =</span> <span class="ot">NULL</span>)
)
<span class="kw">autoplot</span>(bm) <span class="op">+</span><span class="st"> </span><span class="kw">theme_bw</span>()</code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/smartly-select-and-mutate_files/figure-html/benchmark3-1.png" /><!-- --></p>
<p>This puts things back into perspective, I guess :) It might also be interesting to know, how much of the computation time is spent on the non-standard evaluation part of the <code>dplyr</code> and <code>[.data.table</code> implementation, but that’s probably a topic on its own.</p>
</div>
<div id="summary" class="section level2">
<h2>Summary</h2>
<p>Accidently overwriting existing data columns leads to nasty bugs. The presented workflow allows to increase both reliability and precision of standard data frame column manipulation at very little cost. The intended column operations can be expressed more clearly and, in case of failures, informative error messages are provided by default. As a result, the dict-framework may serve as a useful supplement to “interactive piping”.</p>
</div>
</section>
