function n_taw = runpLSA(dataBaseName, imageExt, numFiles, backThresh, staticThresh, docLength, boxSize, numTopics)

	imageStack = generateImageStack(dataBaseName, imageExt, numFiles);

	processedStack = preprocessStack(imageStack, backThresh);

	[freqTable, startTimes] = createWordFrequencies(imageStack, timeSequences, staticThresh, docLength, boxSize)

	[Pw_z,Pd_z,Pz,Li] = pLSA_EM(freqTable, numTopics);

	n_taw = computeCorrelations(Pw_z, freqTable)

return n_taw;