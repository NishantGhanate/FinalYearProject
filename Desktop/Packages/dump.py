        # # Both Image should have same size and channels 
        # print(type(smoothed) , len(smoothed[0]) , len(smoothed))
        # print(type(self.blackImage) , len(self.blackImage[0]) , len(self.blackImage))
        # print(smoothed.shape)
        # print(self.blackImage.shape)
        
        # You can play with iterations values too match your needs
        # dilation = cv2.dilate(fgmask,self._kernel,iterations = 2)
        # erosion = cv2.erode(dilation,self._kernel,iterations = 1)
        # ret,thresh = cv2.threshold(erosion,127,255,0)
        # # im2, contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
        # cv2.imshow(' frame mask ' , thresh)
    