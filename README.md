<a href="https://gitmoji.dev/"><img src="https://img.shields.io/badge/Uses-Gitmoji-brightgreen?style=for-the-badge" />

# Cellular Automata based Edge Detection Script
> TLDR: Cellular Automata simulation for edge detection on binary images, written in Octave.

This repo was my base playground to generate the test results for my [BachelorThesis](BachelorThesis.pdf) about Subwindow Neighborhood aggregation for edge detecting CA. The concept is inspired and adapted from P. L. Rosin's work from 2006 titled "Training cellular automata for image processing".

# How to use
Honestly, this repo is still in a rough state because the experimental testing during my bachelor thesis didn't leave much room for clean code.

But if you have questions, just open an issue and I'll try and help you.

In summary, this octave script performs several steps in order to detect the edges of binary images. For all images that you load into the program it will:
- calculate the ground truth edge image and label it as the optimal result that it'll compare its performance against
- apply a given noise to the image to make the edge detection harder
- run several different cellular automata based edge detection algorithms on it .Currently these are OTCA832, TCA112 (defined by Amrogowicz,  et. al in “An edge detection method using outer Totalistic Cellular Automata”) and my subwindow modified version of them but you can specify your own here)
- denoise the image and then run several state of the art edge detectors on it (sobel, canny, prewitt, roberts)
- and save the results to memory

In the end it'll show one randomly picked result and show the performance over all given Training/Test Images.

# File Structure
- `/images` contains a good amount of binary images split up in test and training set
- `/neighborhoods` contains different cellular automata neighboorhoods that you can use to run the cellular automata algorithm with
- `/subwindows` contains different cellular automata subwindow configurations that you can use to run the cellular automata algorithm with
- `/ruleLookUpTable` contains different lookUp matrixes which I abandoned at the end but the basic idea here is that you generate a list with all the possible patterns that a neighborhood can have (after getting rid of symmetries, mirrored symmetries and rotation equalities) and then define the next cell state based on that
