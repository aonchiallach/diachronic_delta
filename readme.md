## Diachronic Delta

# Introduction

This folder represents the bulk of the technical aspects of my doctoral thesis, 'Diachronic Delta: A Computational and Dialectical Method for Analysing Literary History'. What I set out to do was falsify the notion of a break in literary history, the idea that in modernity a critical mass of literary works enact a significant breach between themselves and their precedessors. Ted Underwood, in his book 'Distant Horizons' had already demonstrated that literary history proceeds incrementally and I was interested in validating it.

My approach was based on cosine distance, both because it seemed uniquely applicable in this context and also because they loom so large within the field of computational literary studies. Cosine distance was adopted in particular because of benchmark studies which have cited is a the best means of clustering texts together on the basis of authorship.

# Methodology

The approach as documented in diachronic_delta.r differs pretty significantly from my original method, which was cumbersome, inefficient and inexact. Originally I also pulled down the word frequency data from HathiTrust itself, as opposed to the yearly summaries they make available, which was, a pretty pointless effort given the extent of the gain was fairly negligible.

I remove the punctuation, blank rows, numerical and other artefacts and then remove every year before an unbroken sequence of years up to 1922 kicks in, as the distribution

#as time goes on in poetry and fiction becomes less novel and less transient 
# the more novel the more transient

#drama not affected by time, but a positive correlation between novelty and transient










