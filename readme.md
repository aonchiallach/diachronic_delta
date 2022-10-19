## Diachronic Delta

# Introduction

This folder represents the bulk of the technical aspects of my doctoral thesis, 'Diachronic Delta: A Computational and Dialectical Method for Analysing Literary History'. What I set out to do was falsify the notion of a break in literary history, the idea that in modernity a critical mass of literary works enact a significant breach between themselves and their precedessors. The first reason I was interested in pursuing this as a topic was the publication of Ted Underwood's book [Distant Horizons](https://press.uchicago.edu/ucp/books/book/chicago/D/bo35853783.html) which I think is the best work for situating computational approaches to literatyre within a literary historico-critical rubric and the second was the extent of the corpus in postwar literary historiography written from a Marxist perspective, which, in very broad terms, advances the idea that modernism, a cultural logic that emerges in the late nineteenth and early twentieth century represents a break from more naively mimetic forms of cultural expression which were hegemonic in the nineteenth century. Exploring this idea while introducing an empirical dimension seemed like an interesting project. 

# Methodology

The approach as it is documented here differs pretty significantly from the one I deployed in my thesis, which was inexact where it needed to be specific and tight where it needed to be loose. For example, I extracted the compressed .tsv word frequency files from [the HathiTrust Word Frequencies dataset itself] (https://wiki.htrc.illinois.edu/display/COM/Word+Frequencies+in+English-Language+Literature%2C+1700-1922) as opposed to the yearly summaries they make available. I did this primarily in order to develop a better understanding of the dataset, explore anything interesting which might arise from relating to the word frequency data to the metadata, but in retrospect, any gain that I attained for this significant amount of effort was fairly negligible.

As can be seen in the r script I remove the punctuation, blank rows, numerical and other artefacts. Every year before an unbroken sequence of years up to 1922 occurs was summed into a single year as the distribution of texts by year is highly skewed to more recent end of the spectrum. I had previously removed these from the analysis altogether but it seems unncessary to discard them for the sake of rigour as such.

I then calculated the distance between each year. I applied wurzburg or cosine distance to the frequency table and calculated the distance each year lies from every other year.  approach was based on cosine distance, both because it seemed uniquely applicable in this context and also because in a [2011 article P. W. H. Smith and W. Aldridge] (https://www.tandfonline.com/doi/abs/10.1080/09296174.2011.533591) have comprehensively proven it to be the best means of optimising [J.F. Burrows' Delta method])https://academic.oup.com/dsh/article-abstract/17/3/267/929277?redirectedFrom=fulltext). The mean distance each year is from every year before it is its 'novelty', every year after it is called 'transience' and we subtract the latter from the former to calculate a third statistic, 'resonance', under the assumption that all three of these allow us to track each year's relative amount of influence within the dataset.

All three of these variables are then normalised. In a statistical analysis of a topic model of the French Revolutionary debates [Barron et al.](https://www.pnas.org/doi/10.1073/pnas.1717729115) identify more than two standard deviations above the mean for both novelty and resonance as indicative as an influential agent. This is the benchmark I adopted here and the results are documented in the next section.

# Results

In all corpora there is a positive correlation between novelty and transience, suggesting that the more novel a year is, the less its influence is transmitted. In the fiction and poetry corpus over time it seems they become less novel and less transient. In this way we might say that dramatic production, such as the dataset we have might be said to serve as an accurate indicator, there is a different dynamic taking place.

In the poetry and drama corpus one year was found which fit this profile, 1748 and 1756 respectively. There were no years in the fiction corpus which did, though 1750 came closest with a novelty of and a resonance of y. Not coincidentally these are the years in each dataset where the number of texts begin to scale upwards significantly. There are greater amounts of words being introduced in these years, just as a function of the amount of works and as a consequence greater amounts of novelty. The numbers of texts continue to increase; these words do not go anywhere, so there is more than a risk that what we are capturing here is a proxy variable for the distribution of texts over time.

# Conclusions / Future Work

Larger corpus


















