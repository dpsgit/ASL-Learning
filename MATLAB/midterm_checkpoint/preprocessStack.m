function imageStackPost = preprocessStack(imageStack, backThresh)
    imageStackPost = imageStack - backThresh;
    imageStackPost(imageStackPost < 0) = 0;
end