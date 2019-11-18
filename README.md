# ASD project

(Detection of autism spectrum disorder (ASD) from electrocardiogram (ECG))

Related manuscript can be found [here](https://arxiv.org/abs/1808.08306).

The purpose of this repo is to share the HRV processing pipeline and the machine learning model we found to perform best on our n=68 subjects data set. See the manuscript for details of results and model performance.

The Matlab code shared here has been contributed by the manuscript's co-author Prof. Hau-Tieng Wu and his PhD student Chao Shen of Duke University. 

See license TXTs in the respective subdirectories for the detailed information on the original authors of each code. 
This compilation reproduces the exact HRV analysis pipeline of the corresponding [arXiv manuscript](https://arxiv.org/abs/1808.08306). 

The HRV pipeline includes RRs artifact processing and calculation of the reported HRV measures. For details, please see the arXiv manuscript.

!!! We are looking for interested individual(s) to help port the entire code base into one cohesive app, probably Python-based, to enable API-style utilization of the proposed approach to identifying children with ASD, CD, depression or typical development using ECG recordings in future studies.

[![DOI](https://zenodo.org/badge/179379650.svg)](https://zenodo.org/badge/latestdoi/179379650)
