## Diachronic Delta

# Introduction

This folder represents the bulk of the technical aspects of my doctoral thesis, 'Diachronic Delta: A Computational and Dialectical Method for Analysing Literary History'. What I set out to do was falsify the notion of a break in literary history, the idea that in modernity a critical mass of literary works enact a significant breach between themselves and their precedessors. Ted Underwood's book 'Distant Horizons' was part the reason I was interested in answering this question.

My approach was based on cosine distance, both because it seemed uniquely applicable in this context and also because in a 2011 article P. W. H. Smith and W. Aldridge have comprehensively proven it to be the best means of optimising J.F. Burrows' Delta method.

# Methodology

The approach as enacted here differs pretty significantly from the one I deployed in my thesis, which was inexact where it needed to be specific and tight where it needed to be loose. In more specific terms, I also extracted the compressed .tsv word frequency files from the HathiTrust itself as opposed to the yearly summaries they make available. I did this primarily in order to develop a better understanding of the dataset, explore anything interesting which might arise from relating to the word frequency data to the metadata, but taking an overall picture, any gain for this significant amount of effort was fairly negligible.

In sum I remove the punctuation, blank rows, numerical and other artefacts. Every year before an unbroken sequence of years up to 1922 occurs was summed into a single year as the distribution of texts by year is highly skewed to the right. I had previously removed these from the analysis altogether but it seems unncessary to discard them for the sake of rigour as such.

Cosine distance is calculated between each year and the mean distance each year is from every year both before and after is calculated. The distance going backwards is novelty, the distance forwards is transience and a third statistic, resonance, is calculated by subtracted the second from the first.

All three of these variables are then normalised and it is found that there are no years that satisfy the model established by Barron et al., i.e. no years are more than two standard deviations above the mean for novelty and resonance and there is therefore no evidence of a break in the sense that is discussed or perhaps taken for granted in some sections of the literary critic historiography.

# Results

In all corpora there is a positive correlation between novelty and transience, suggesting that the more novel a year is, the less its influence is transmitted. In the fiction and poetry corpus over time it seems they become less novel and less transient. In this way we might say that dramatic production, such as the dataset we have might be said to serve as an accurate indicator, there is a different dynamic taking place.















